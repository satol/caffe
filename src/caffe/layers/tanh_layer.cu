// Copyright 2014 Aravindh Mahendran
// TanH neuron activation function layer. Adapted from ReLU layer code written by Yangqing Jia

#include "caffe/layer.hpp"
#include "caffe/vision_layers.hpp"
#include <algorithm>

namespace caffe {

template <typename Dtype>
void TanHLayer<Dtype>::Forward_cpu(const vector<Blob<Dtype>*>& bottom,
    vector<Blob<Dtype>*>* top) {
  const Dtype* bottom_data = bottom[0]->cpu_data();
  Dtype* top_data = (*top)[0]->mutable_cpu_data();
  Dtype exp2x;
  const int count = bottom[0]->count();
  for (int i = 0; i < count; ++i) {
    exp2x = exp(2*bottom_data[i]);
    top_data[i] = (exp2x - Dtype(1))/(exp2x + Dtype(1));
  }
}

template <typename Dtype>
Dtype TanHLayer<Dtype>::Backward_cpu(const vector<Blob<Dtype>*>& top,
    const bool propagate_down,
    vector<Blob<Dtype>*>* bottom) {
  if (propagate_down) {
    const Dtype* bottom_data = (*bottom)[0]->cpu_data();
    const Dtype* top_diff = top[0]->cpu_diff();
    Dtype* bottom_diff = (*bottom)[0]->mutable_cpu_diff();
    const int count = (*bottom)[0]->count();
    Dtype exp2x;
    Dtype tanhx;
    for (int i = 0; i < count; ++i) {
      exp2x = exp(2*bottom_data[i]);
      tanhx = (exp2x - Dtype(1))/(exp2x + Dtype(1));
      bottom_diff[i] = top_diff[i] * (1 - tanhx*tanhx);
    }
  }
  return Dtype(0);
}

template <typename Dtype>
__global__ void TanHForward(const int n, const Dtype* in, Dtype* out) {
  int index = threadIdx.x + blockIdx.x * blockDim.x;
  if (index < n) {
    Dtype exp2x = exp(2*in[index]);
    out[index] = (exp2x - Dtype(1))/(exp2x + Dtype(1));
  }
}

template <typename Dtype>
void TanHLayer<Dtype>::Forward_gpu(const vector<Blob<Dtype>*>& bottom,
    vector<Blob<Dtype>*>* top) {
  const Dtype* bottom_data = bottom[0]->gpu_data();
  Dtype* top_data = (*top)[0]->mutable_gpu_data();
  const int count = bottom[0]->count();
  TanHForward<Dtype><<<CAFFE_GET_BLOCKS(count), CAFFE_CUDA_NUM_THREADS>>>(
      count, bottom_data, top_data);
  CUDA_POST_KERNEL_CHECK;
  // << " count: " << count << " bottom_data: "
  //     << (unsigned long)bottom_data << " top_data: " << (unsigned long)top_data
  //     << " blocks: " << CAFFE_GET_BLOCKS(count)
  //     << " threads: " << CAFFE_CUDA_NUM_THREADS;
}

template <typename Dtype>
__global__ void TanHBackward(const int n, const Dtype* in_diff,
    const Dtype* in_data, Dtype* out_diff) {
  int index = threadIdx.x + blockIdx.x * blockDim.x;
  if (index < n) {
    Dtype exp2x = exp(2*in_data[index]);
    Dtype tanhx = (exp2x - Dtype(1))/(exp2x + Dtype(1));
    out_diff[index] = in_diff[index] * (1 - tanhx*tanhx);
  }
}

template <typename Dtype>
Dtype TanHLayer<Dtype>::Backward_gpu(const vector<Blob<Dtype>*>& top,
    const bool propagate_down,
    vector<Blob<Dtype>*>* bottom) {
  if (propagate_down) {
    const Dtype* bottom_data = (*bottom)[0]->gpu_data();
    const Dtype* top_diff = top[0]->gpu_diff();
    Dtype* bottom_diff = (*bottom)[0]->mutable_gpu_diff();
    const int count = (*bottom)[0]->count();
    TanHBackward<Dtype><<<CAFFE_GET_BLOCKS(count), CAFFE_CUDA_NUM_THREADS>>>(
        count, top_diff, bottom_data, bottom_diff);
    CUDA_POST_KERNEL_CHECK;
  }
  return Dtype(0);
}

INSTANTIATE_CLASS(TanHLayer);


}  // namespace caffe
