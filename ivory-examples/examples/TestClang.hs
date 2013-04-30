import System.Environment

import qualified PID
import qualified FibLoop
import qualified Factorial
import qualified String
import qualified FunPtr
import qualified Overflow
import qualified Float
import qualified Alloc
import qualified Area
import qualified Cond
import qualified Forever
import qualified PublicPrivate
import qualified Bits

import Ivory.Compile.C.CmdlineFrontend
import Ivory.Language (Module)

main :: IO ()
main = do
  args <- getArgs
  let path = head args
  let opts = initialOpts { includeDir = path, srcDir = path
                         , rtIncludeDir = Nothing }
  runCompiler modules opts
  Overflow.writeOverflow opts

modules :: [Module]
modules = [ PID.cmodule
          , FibLoop.cmodule
          , Factorial.cmodule
          , String.cmodule
          , FunPtr.cmodule
          , Overflow.cmodule
          , Float.cmodule
          , Alloc.cmodule
          , Area.cmodule
          , Cond.cmodule
          , Forever.cmodule
          , PublicPrivate.cmodule
          , Bits.cmodule
          ]