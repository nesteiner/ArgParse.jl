struct Flag
  name::String
  short::Union{String, Nothing}
  long::Union{String, Nothing}
  help::String
  required::Bool

  function Flag(;
                name::String,
                short::Union{String, Nothing} = nothing,
                long::Union{String, Nothing} = nothing,
                help::String,
                required::Bool = false)

    @assert !isnothing(short) || !isnothing(long) "short or long must be non null"
    return new(
      name,
      short,
      long,
      help,
      required
    )
  end
end

