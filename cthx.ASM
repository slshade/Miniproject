format PE console 4.0
 
include 'win32a.inc'
start:


      fld  [X]
      fld  [X]
      fmulp st1, st0
      fstp [X2]     ;����������� x^2



       ;���������� ch(x)
        finit
        fldz                            ;st(3)  i=1
        fld     [X2]                     ;st(2)  x^2
        fld1                        ;st(1)  Sum=1
        fld1                       ;st(0)  prev=1

        @@repeat:
                fmul    st0,  st2   ;prev *= x^2
                fld1                    ;i=i+1
                faddp   st4,  st0
                fdiv    st0,  st3   ;prev /= (i+1)
                fld1
                faddp   st4,  st0

                fdiv    st0,  st3   ;prev /= (i+2)
                                        ;i=i+2

                fadd    st1,  st0   ;Sum=Sum+now
 
                fld     st0
                fabs                    ;���� now �� ������ ������ ��� Eps, �� ��������� ����������, �.�. ���������� ������� ��������
                fcomp   [Eps]
                fstsw   ax
                sahf
 
        jae     @@repeat               ;���� �� ����������, �� ���������� ������� ��������� ����� ����
        fxch    st1
        fstp    [ResultCHX]

        ;��������� ���������� sh(x)
        finit
        fld1                            ;st(3)  i=1
        fld     [X]                     ;st(2)  x^2
        fld     st0                   ;st(1)  Sum=x
        fmul    st1,  st0           ;st(0)  previous=x
        fld     st0
        @@repeat2:
                fmul    st0,  st2   ;previous *= x^2
                fld1                    ;i=i+1
                faddp   st4,  st0
                fdiv    st0,  st3   ;previous /= (i+1)
                fld1
                faddp   st4,  st0
                fdiv    st0,  st3   ;previous /= (i+2)
                                        ;i=i+2
 
                fadd    st1,  st0   ;Sum=Sum+now
 
                fld     st0
                fabs                    ; now < Eps
                fcomp   [Eps]
                fstsw   ax
                sahf
 
        jae     @@repeat2
        fxch    st1
        fstp    [ResultSHX]



;cth(x) ����������� ��� sh(x) / ch(x)

        fld     [ResultSHX]     ;st(1) = sh(x)
        fld     [ResultCHX]     ;st(0) = ch(x)
        fdiv    st0, st1 ; st(0) = ch/sh
        fstp   [ResultCTH] ;ResultCTH = cth(x)


        cinvoke printf, tpo, dword[ResultCTH], dword[ResultCTH + 4] ;����� ����������

        cinvoke scanf, tpt, X   ;�������� �������



        tpt db  '%f',0      ;��� �������� �������
        tpo db  'cth(x) = %f    ',0     ;��� ������ ����� � �������
        X2   dq ?    ;X^2
        X   dq  0.21 ;�, ��� �������� ����������� ��������
        Eps             dq      0.00000001      ;���������� � ��������� �� eps
        ResultSHX       dq      ?               ;SH(X)
        ResultCHX       dq      ?               ;CH(X)
        ResultCTH       dq      ?               ;CTH(X)




;��� ������ � �������
 data import
 
 library msvcrt,'MSVCRT.DLL'
 
 import msvcrt,\
    scanf,'scanf',\
    printf,'printf'
end data