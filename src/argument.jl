struct Argument{T}
  name::String
  short::Union{String, Nothing}
  long::Union{String, Nothing}
  default::T
  help::String
  required::Bool

  function Argument(E::DataType;
                    name::String,
                    short::Union{String, Nothing} = nothing,
                    long::Union{String, Nothing} = nothing,
                    default::T,
                    help::String,
                    required::Bool = false) where T

    @assert !isnothing(short) || !isnothing(long) "short or long must be non null"
    return new{E}(
      name,
      short,
      long,
      default,
      help,
      required
    )
  end

end

eltype(arg::Argument{T}) where T = T