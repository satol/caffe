// Copyright 2013 Yangqing Jia

#ifndef CAFFE_COMMON_CPP_HPP_
#define CAFFE_COMMON_CPP_HPP_

#include <boost/random/mersenne_twister.hpp>
#include "common.hpp"

namespace caffe {

    typedef boost::mt19937 random_generator_t;
    inline random_generator_t& cast_generator(Caffe::random_generator_t& g)
    {
        return *(caffe::random_generator_t*)g.generator();
    }
    inline const random_generator_t& cast_generator(const Caffe::random_generator_t& g)
    {
        return *(caffe::random_generator_t*)g.generator();
    }

}  // namespace caffe

#endif  // CAFFE_COMMON_HPP_
