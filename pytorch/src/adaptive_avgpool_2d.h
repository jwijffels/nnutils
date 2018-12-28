#ifndef NNUTILS_PYTORCH_ADAPTIVE_AVGPOOL_2D_H_
#define NNUTILS_PYTORCH_ADAPTIVE_AVGPOOL_2D_H_

namespace at {

class Tensor;
}  // namespace at
namespace c10 {
class Device;
template <typename T> class optional;
}  // namespace c10
namespace pybind11 { class object; }

namespace nnutils {
namespace pytorch {

// The same class is declared in two different namespaces.
#define DECLARE_CLASS                                                       \
class AdaptiveAvgpool2dLauncher {                                           \
public:                                                                     \
  template <typename T>                                                     \
  void Forward(                                                             \
      const long int N, const long int C,                                   \
      const long int iH, const long int iW,                                 \
      const long int oH, const long int oW,                                 \
      const long int* xs, const long int* ys,                               \
      const T* x, T* y, const c10::Device& device);                         \
                                                                            \
  template <typename T>                                                     \
  void Backward(                                                            \
      const long int N, const long int C,                                   \
      const long int iH, const long int iW,                                 \
      const long int oH, const long int oW,                                 \
      const long int* xs, const long int* ys,                               \
      const T* grad_y, T* grad_x, const c10::Device& device);               \
}

namespace cpu { DECLARE_CLASS; }  // namespace cpu
#ifdef WITH_CUDA
namespace gpu { DECLARE_CLASS; }  // namespace gpu
#endif  // WITH_CUDA

void adaptive_avgpool_2d_fwd(
    const at::Tensor& x, at::Tensor& y,
    const c10::optional<at::Tensor>& xs, const c10::optional<at::Tensor>& ys);

void adaptive_avgpool_2d_bwd(
    const at::Tensor& grad_y, at::Tensor& grad_x,
    const c10::optional<at::Tensor>& xs, const c10::optional<at::Tensor>& ys);

}  // namespace pytorch
}  // namespace nnutils

#undef DECLARE_CLASS
#endif  // NNUTILS_PYTORCH_ADAPTIVE_AVGPOOL_2D_H_
