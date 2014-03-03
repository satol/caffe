// Copyright 2013 Yangqing Jia

#ifndef CAFFE_COMMON_CPP_HPP_
#define CAFFE_COMMON_CPP_HPP_

#include <boost/random/mersenne_twister.hpp>
#include "common.hpp"

namespace caffe {

  typedef boost::mt19937 system_random_generator_t;
  inline system_random_generator_t& cast_generator(Caffe::random_generator_t& g)
  {
    return *(caffe::system_random_generator_t*)g.generator();
  }
  inline const system_random_generator_t& cast_generator(const Caffe::random_generator_t& g)
  {
    return *(caffe::system_random_generator_t*)g.generator();
  }

}  // namespace caffe

#endif  // CAFFE_COMMON_HPP_
