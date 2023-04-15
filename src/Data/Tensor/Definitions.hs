module Data.Tensor.Definitions where

import Data.Vector.Storable (Storable, Vector)
import Data.Tensor.Index

import Foreign.C.Types

-- | Tensor data type.
data (Storable t) =>
  Tensor t = Tensor {
    -- | Tensor shape.
    shape :: !Index,
    -- | Data stride in bytes, analogous to NumPy array stride.
    tensorStride :: !Index,
    -- | Data offset in bytes.
    tensorOffset :: !CInt,
    -- | Internal data representation.
    tensorData :: !(Vector t)
  }

-- | Advanced indexer data type.
type TensorIndex = [Tensor CInt]

-- | Typeclass for numerical operations.
class (Storable t, Num t) => NumTensor t where
  -- | Return a 2-D tensor with ones
  --   on the diagonal and zeros elsewhere.
  --
  --   @diagonalIndex@ 0 refers to the main diagonal,
  --   a positive value refers to an upper diagonal,
  --   and a negative value to a lower diagonal.
  --
  --   Signature: @rows -> columns -> diagonalIndex -> tensor@
  eye:: CInt -> CInt -> CInt -> Tensor t

  -- | Return evenly spaced values within a given interval.
  --
  --   Example: @arange 0 3 1 = tensor([0, 1, 2])@
  --
  --   Signature: @low -> high -> step -> tensor@
  arange:: t -> t -> t -> Tensor t

  -- | Sum elements of a tensor.
  sum:: Tensor t -> t

  numTAdd :: Tensor t -> Tensor t -> Tensor t
  numTSub :: Tensor t -> Tensor t -> Tensor t
  numTMult :: Tensor t -> Tensor t -> Tensor t
  numTNegate :: Tensor t -> Tensor t
  numTAbs :: Tensor t -> Tensor t
  numTSignum :: Tensor t -> Tensor t

-- | Typeclass for fractional operations.
class (Storable t, Fractional t, NumTensor t) => FractionalTensor t where
  fracTDiv :: Tensor t -> Tensor t -> Tensor t

-- | Typeclass for floating operations.
class (Storable t, Floating t, FractionalTensor t) => FloatingTensor t where
  -- | Returns True if two arrays are element-wise equal within a tolerance.
  allCloseTol :: t -> t -> Tensor t -> Tensor t -> Bool

  -- | Returns True if two arrays are element-wise equal within a default tolerance.
  allClose :: Tensor t -> Tensor t -> Bool
  allClose = allCloseTol 1e-05 1e-08

  floatTExp :: Tensor t -> Tensor t
  floatTLog :: Tensor t -> Tensor t
  floatTSin :: Tensor t -> Tensor t
  floatTCos :: Tensor t -> Tensor t
  floatTAsin :: Tensor t -> Tensor t
  floatTAcos :: Tensor t -> Tensor t
  floatTAtan :: Tensor t -> Tensor t
  floatTSinh :: Tensor t -> Tensor t
  floatTCosh :: Tensor t -> Tensor t
  floatTAsinh :: Tensor t -> Tensor t
  floatTAcosh :: Tensor t -> Tensor t
  floatTAtanh :: Tensor t -> Tensor t
