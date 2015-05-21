{-# LANGUAGE RecordWildCards, TemplateHaskell, ViewPatterns #-}

module Network.URI.Static
    ( staticURI
    , uri
    ) where

import Language.Haskell.TH (unType)
import Language.Haskell.TH.Lib (TExpQ)
import Language.Haskell.TH.Quote (QuasiQuoter(..))
import Language.Haskell.TH.Syntax (Lift(..))
import Network.URI (URI(..), URIAuth(..), parseURI)

staticURI :: String -> TExpQ URI
staticURI (parseURI -> Just uri) = [|| uri ||]
staticURI uri = fail $ "Invalid URI: " ++ uri

instance Lift URI where
    lift (URI {..}) = [| URI {..} |]

instance Lift URIAuth where
    lift (URIAuth {..}) = [| URIAuth {..} |]

uri :: QuasiQuoter
uri = QuasiQuoter {
    quoteExp = fmap unType . staticURI,
    quotePat = undefined,
    quoteType = undefined,
    quoteDec = undefined
}
