/****************************************************************
        Cosmos HAL全局数据结构头文件halglobal_t.h
*****************************************************************
                彭东
****************************************************************/
#ifndef _HALGLOBAL_T_H
#define _HALGLOBAL_T_H
// 全局变量定义变量放在 data 段
#define HAL_DEFGLOB_VARIABLE(vartype,varname) \
EXTERN  __attribute__((section(".data"))) vartype varname

#endif // HALGLOBAL_T_H
