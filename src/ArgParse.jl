module ArgParse
import Base.eltype

include("argument.jl")
include("flag.jl")
include("parse.jl")

export Argument, Flag, parseArgs, parseFlags, parseArgsAndFlags
end # module
