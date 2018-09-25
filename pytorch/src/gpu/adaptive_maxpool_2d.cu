#include <ATen/Context.h>
#include <ATen/Device.h>
#include <ATen/DeviceGuard.h>
#include <nnutils/gpu/adaptive_maxpool_2d.h>

#include <cstdint>

#include "../adaptive_maxpool_2d.h"

namespace nnutils {
namespace pytorch {
namespace gpu {

template <typename T>
void AdaptiveMaxpool2dLauncher::Forward(
    const long int N, const long int C,
    const long int iH, const long int iW,
    const long int oH, const long int oW,
    const long int* xs, const long int* ys,
    const T* x, T* y, long int* index, const at::Device& device) {
  at::DeviceGuard device_guard(device);
  auto stream =
      at::globalContext().getCurrentCUDAStreamOnDevice(device.index()).stream();
  nnutils::gpu::adaptive_maxpool_2d_fwd(
      N, C, iH, iW, oH, oW, xs, ys, x, y, index, stream);
}

template <typename T>
void AdaptiveMaxpool2dLauncher::Backward(
      const long int N, const long int C,
      const long int iH, const long int iW,
      const long int oH, const long int oW,
      const long int* index, const long int* out_sizes,
      const T* g_output, T* g_input, const at::Device& device) {
  at::DeviceGuard device_guard(device);
  auto stream =
      at::globalContext().getCurrentCUDAStreamOnDevice(device.index()).stream();
  nnutils::gpu::adaptive_maxpool_2d_bwd(
      N, C, iH, iW, oH, oW, out_sizes, index, g_output, g_input, stream);
}


#define INSTANTITATE_OPERATOR(TYPE)                                       \
template void AdaptiveMaxpool2dLauncher::Forward<TYPE>(                   \
    const long int N, const long int C,                                   \
    const long int iH, const long int iW,                                 \
    const long int oH, const long int oW,                                 \
    const long int* xs, const long int* ys,                               \
    const TYPE* x, TYPE* y, long int* index, const at::Device& device);   \
                                                                          \
template void AdaptiveMaxpool2dLauncher::Backward<TYPE>(                  \
    const long int N, const long int C,                                   \
    const long int iH, const long int iW,                                 \
    const long int oH, const long int oW,                                 \
    const long int* index, const long int* out_sizes,                     \
    const TYPE* g_output, TYPE* g_input, const at::Device& device)

INSTANTITATE_OPERATOR(double);
INSTANTITATE_OPERATOR(float);

#undef INSTANTITATE_OPERATOR
}  // namespace gpu
}  // namespace pytorch
}  // namespace nnutils
