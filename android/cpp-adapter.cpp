#include <jni.h>
#include "lwk-rn.h"

extern "C"
JNIEXPORT jdouble JNICALL
Java_com_lwkrn_LwkRnModule_nativeMultiply(JNIEnv *env, jclass type, jdouble a, jdouble b) {
    return lwkrn::multiply(a, b);
}
