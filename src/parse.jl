function parseArgsAndFlags(;original::Vector{String}, args::Vector{Argument}, flags::Vector{Flag})::Dict{String, Any}
  

  predicate = predicateFlag
  isflag(ostring::String)::Bool = begin
    index = findfirst(flag -> predicate(flag, ostring), flags)
    return !isnothing(index)
  end

  indexs = findall(isflag, original)
  originalFlags = original[indexs]
  deleteat!(original, indexs)
  originalArgs = original

  validateArgs(originalArgs, args)
  validateFlags(originalFlags, flags)

  flagdict = parseFlags(originalFlags = originalFlags, flags = flags)
  argdict = parseArgs(originalArgs = originalArgs, args = args)

  return merge(argdict, flagdict)
end

function parseArgs(; originalArgs::Vector{String}, args::Vector{Argument})::Dict{String, Any}

  dict = Dict{String, Any}()
  for arg in args
    dict[arg.name] = arg.default
  end
  
  while !isempty(originalArgs)
    (arg, value, width) = findFirstOriginalArg(originalArgs, args)
    dict[arg.name] = value

    for _ in 1:width
      popfirst!(originalArgs)
    end
  end

  return dict
end

function parseFlags(; originalFlags::Vector{String}, flags::Vector{Flag})::Dict{String, Bool}
  dict = Dict{String, Bool}()
  for flag in flags
    dict[flag.name] = false

    if findFirstFlag(originalFlags, flag)
      dict[flag.name] = true
      popfirst!(originalFlags)
    end
  end

  return dict
  
end

function validateArgs(originalArgs::Vector{String}, args::Vector{Argument})
  for arg in args
    if arg.required
      index = findfirst(oarg -> predicateArg(arg, oarg), originalArgs)
      if isnothing(index)
        throw("cannot find required argument: $(arg.name)")
      end
    end
  end
end

function validateFlags(originalFlags::Vector{String}, flags::Vector{Flag})
  for flag in flags
    if flag.required
      index = findfirst(oflag -> predicateFlag(flag, oflag), originalFlags)
      if isnothing(index)
        throw("cannot find required flag: $(flag.name)")
      end
    end
  end
end

function findFirstOriginalArg(originalArgs::Vector{String}, args::Vector{Argument})::Tuple{Argument, Any, Int}
  width = 1
  originalArg = first(originalArgs)

  predicate = predicateArg
  index = findfirst(arg -> predicate(arg, originalArg), args)
  if isnothing(index)
    throw("cannot find match argument: $originalArg")
  end

  arg = args[index]
  value = nothing
  type = eltype(arg)
  if type <: AbstractVector
    index = 2
    value = String[]
    while index <= length(originalArgs) && !startswith(originalArgs[index], '-')
      element = eltype(type) <: AbstractString ? originalArgs[index] : parse(type, originalArgs[index])
      push!(value, element)
      index += 1
      width += 1
    end
  else
    width += 1
    element = type <: AbstractString ? originalArgs[2] : parse(type, originalArgs[2])
    value = element
  end

  return (arg, value, width)
end

function findFirstFlag(originalFlags::Vector{String}, flag::Flag)::Bool
  isempty(originalFlags) && return false
  originalFlag = first(originalFlags)

  predicate = predicateFlag
  index = findfirst(oflag -> predicate(flag, oflag), originalFlags)

  return !isnothing(index)
end

function predicateArg(arg::Argument, oarg::String)
  if startswith(oarg, "--") && !isnothing(arg.long)
    return arg.long == oarg
  elseif startswith(oarg, "-") && !isnothing(arg.short)
    return arg.short == oarg
  else
    return false
  end
end

function predicateFlag(flag::Flag, oflag::String)
  if startswith(oflag, "--") && !isnothing(flag.long)
    return flag.long == oflag
  elseif startswith(oflag, "-") && !isnothing(flag.short)
    return flag.short == oflag
  else
    return false
  end
end