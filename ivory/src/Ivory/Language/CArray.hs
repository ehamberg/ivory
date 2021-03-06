{-# OPTIONS_GHC -fno-warn-orphans #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE KindSignatures #-}

{-# LANGUAGE UndecidableInstances #-}
{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE MultiParamTypeClasses #-}

module Ivory.Language.CArray where

import Ivory.Language.Area
import Ivory.Language.Proxy
import Ivory.Language.Ref
import Ivory.Language.Struct
import Ivory.Language.Type
import qualified Ivory.Language.Syntax as I

import GHC.TypeLits (SingI)


instance IvoryType a => IvoryType (CArray a) where
  ivoryType _ = I.TyCArray (ivoryType (Proxy :: Proxy a))


-- | Guard invocations of toCArray.
class (IvoryType area, IvoryType rep)
  => ToCArray (area :: Area) (rep :: Area) | area -> rep

instance (SingI len, ToCArray area rep)
    => ToCArray (Array len area) (CArray rep)
instance IvoryType a => ToCArray (Stored a) (Stored a)
instance IvoryStruct sym => ToCArray (Struct sym) (Struct sym)

-- | Convert from a checked array to one that can be given to a c function.
toCArray :: forall s len area rep ref.
            ( SingI len, ToCArray area rep, IvoryRef ref
            , IvoryExpr (ref s (Array len area))
            , IvoryExpr (ref s (CArray rep)))
         => ref s (Array len area) -> ref s (CArray rep)
toCArray ref = wrapExpr $ I.ExpSafeCast ty (unwrapExpr ref)
  where ty = ivoryType (Proxy :: Proxy (ref s (CArray rep)))
