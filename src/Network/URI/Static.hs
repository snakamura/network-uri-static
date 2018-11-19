{-# LANGUAGE CPP, RecordWildCards, TemplateHaskell, ViewPatterns #-}

#if MIN_VERSION_network_uri(2,7,0)
#else

module Network.URI.Static
    (
    -- * Absolute URIs
      uri
    , staticURI
    -- * Relative URIs
    , relativeReference
    , staticRelativeReference
    ) where

import Language.Haskell.TH (unType)
import Language.Haskell.TH.Lib (TExpQ)
import Language.Haskell.TH.Quote (QuasiQuoter(..))
import Language.Haskell.TH.Syntax (Lift(..))
import Network.URI (URI(..), URIAuth(..), parseURI, parseRelativeReference)

-- $setup
-- >>> :set -XTemplateHaskell
-- >>> :set -XQuasiQuotes

----------------------------------------------------------------------------
-- Absolute URIs
----------------------------------------------------------------------------

-- | 'staticURI' parses a specified string at compile time
--   and return an expression representing the URI when it's a valid URI.
--   Otherwise, it emits an error.
--
-- >>> $$(staticURI "http://www.google.com/")
-- http://www.google.com/
--
-- >>> $$(staticURI "http://www.google.com/##")
-- <BLANKLINE>
-- <interactive>...
-- ... Invalid URI: http://www.google.com/##
-- ...
staticURI :: String -- ^ String representation of a URI
          -> TExpQ URI -- ^ URI
staticURI (parseURI -> Just uri) = [|| uri ||]
staticURI uri = fail $ "Invalid URI: " ++ uri

-- | 'uri' is a quasi quoter for 'staticURI'.
--
-- >>> [uri|http://www.google.com/|]
-- http://www.google.com/
--
-- >>> [uri|http://www.google.com/##|]
-- <BLANKLINE>
-- <interactive>...
-- ... Invalid URI: http://www.google.com/##
-- ...
uri :: QuasiQuoter
uri = QuasiQuoter {
    quoteExp = fmap unType . staticURI,
    quotePat = undefined,
    quoteType = undefined,
    quoteDec = undefined
}

----------------------------------------------------------------------------
-- Relative URIs
----------------------------------------------------------------------------

-- | 'staticRelativeReference' parses a specified string at compile time and
--   return an expression representing the URI when it's a valid relative
--   reference. Otherwise, it emits an error.
--
-- >>> $$(staticRelativeReference "/foo?bar=baz#quux")
-- /foo?bar=baz#quux
--
-- >>> $$(staticRelativeReference "http://www.google.com/")
-- <BLANKLINE>
-- <interactive>...
-- ... Invalid relative reference: http://www.google.com/
-- ...
staticRelativeReference :: String -- ^ String representation of a reference
                        -> TExpQ URI -- ^ Refererence
staticRelativeReference (parseRelativeReference -> Just ref) = [|| ref ||]
staticRelativeReference ref = fail $ "Invalid relative reference: " ++ ref

-- | 'relativeReference' is a quasi quoter for 'staticRelativeReference'.
--
-- >>> [relativeReference|/foo?bar=baz#quux|]
-- /foo?bar=baz#quux
--
-- >>> [relativeReference|http://www.google.com/|]
-- <BLANKLINE>
-- <interactive>...
-- ... Invalid relative reference: http://www.google.com/
-- ...
relativeReference :: QuasiQuoter
relativeReference = QuasiQuoter {
    quoteExp = fmap unType . staticRelativeReference,
    quotePat = undefined,
    quoteType = undefined,
    quoteDec = undefined
}

----------------------------------------------------------------------------
-- Instances and helpers
----------------------------------------------------------------------------

instance Lift URI where
    lift (URI {..}) = [| URI {..} |]

instance Lift URIAuth where
    lift (URIAuth {..}) = [| URIAuth {..} |]

#endif
