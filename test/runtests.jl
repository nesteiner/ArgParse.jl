using Test, ArgParse

# @testset "print parsed args" begin
#   oargs = ["--arg1", "1", "--arg2", "hello", "--arg3", "hello", "world", "--arg4", "fuck"]
#   args = [Argument(String, name = "arg1", long = "--arg1", help = "arg1", default = "hello1"),
#           Argument(String, name = "arg2", long = "--arg2", help = "arg2", default = "hello2"),
#           Argument(Vector{String}, name = "arg3", long = "--arg3", help = "arg3", default = ["hello3", "fuck"]),
#           Argument(String, name = "arg4", long = "--arg4", help = "arg4", default = "hello4")]
#   dict = parseArgs(originalArgs = oargs, args = args)
#   println(dict)
# end

# @testset "print parsed flags" begin
#   oflags = ["--flag1"]

#   flags = [Flag(name = "flag1", long = "--flag1", help = "flag1"),
#            Flag(name = "flag2", long = "--flag2", help = "flag2"),
#            Flag(name = "flag3", long = "--flag3", help = "flag3")]

#   dict = parseFlags(originalFlags = oflags, flags = flags)
#   println(dict)
# end

@testset "print parsed args and flags" begin
  ARGS = ["--arg1", "1", "--arg2", "hello", "world", "--flag1", "-f", "-a", "1.0"]

  args = [Argument(Int, name = "arg1", long = "--arg1", help = "arg1", default = 0),
          Argument(Vector{String}, name = "arg2", long = "--arg2", help = "arg2", default = String[]),
          Argument(String, name = "arg3", long = "--arg3", help = "arg3", default = "arg3", required = false),
          Argument(Float64, name = "arg4", short = "-a", help = "arg4", default = 0.0)]
  
  flags = [Flag(name = "flag1", long = "--flag1", help = "flag1"),
           Flag(name = "flag2", short = "-f", help = "flag2")]
  
  dict = parseArgsAndFlags(original = ARGS, args = args, flags = flags)
  println(dict)

end