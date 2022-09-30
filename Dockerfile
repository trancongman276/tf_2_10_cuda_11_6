FROM doku9652/tf_cuda:11.6.2-delve

ENV PYTHON_BIN_PATH=/usr/bin/python3
ENV PYTHON_LIB_PATH=/usr/lib/python3/dist-packages
ENV TF_NEED_ROCM=0
ENV TF_CUDA_COMPUTE_CAPABILITIES=7.5
ENV TF_CUDA_CLANG=0
ENV GCC_HOST_COMPILER_PATH=/usr/bin/gcc
ENV CC_OPT_FLAGS=-Wno-sign-compare
ENV TF_SET_ANDROID_WORKSPACE=0

ARG TF_VERSION=2.10.0

RUN wget https://github.com/tensorflow/tensorflow/archive/refs/tags/v${TF_VERSION}.zip -O tensorflow.zip && \
    unzip tensorflow.zip && rm tensorflow.zip
RUN cd tensorflow-${TF_VERSION} && sh ./configure && \
    bazel build --config=opt --config=cuda //tensorflow/tools/pip_package:build_pip_package && \
    ./bazel-bin/tensorflow/tools/pip_package/build_pip_package /mnt && \
    chown $HOST_PERMS /mnt/tensorflow-${TF_VERSION}.whl
