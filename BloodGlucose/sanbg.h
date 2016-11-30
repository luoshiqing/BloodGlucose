//========================================================================
//
// File: sanbg.h
//
// Description: 
//
// Created:2014.5
//
// Author: TONG Bin  www.wicoolsoft.com
//
//========================================================================


//----------------------------------
//      global  definition
//----------------------------------

#define BGC_OK	0				//����

//about current
#define BGC_CURRENT_ZERO 		1	//����Ϊ�㡣�����������ڻ������
#define BGC_CURRENT_TOOLOW		2	//�������͡���������С���趨����Сֵ
#define BGC_CURRENT_TOOHIGH		3	//�������ߡ��������������趨�����ֵ

//about bg  
#define BGC_BG_NONE				1	//���ܽ���ת������δ����α�
#define BGC_BG_ERRORCURRENT		2	//��ǰ�����쳣
#define BGC_BG_ERRORK			3	//��ǰKֵ�쳣
#define BGC_BG_ROC				4   //Ѫ��ROC�쳣

//about k
#define BGC_K_TOOLOW			1	//�����KֵС���趨����Сֵ
#define BGC_K_TOOHIGH			2	//�����Kֵ�����趨�����ֵ


//about trend
#define BGC_TREND_SHARPRISE		0	//��������
#define BGC_TREND_RISE  		1	//����
#define BGC_TREND_STEADY		3	//�ȶ�
#define BGC_TREND_FALL			4	//�½�
#define BGC_TREND_SHARPFALL		5	//�����½�
#define BGC_TREND_UNCLEAR		6	//���Ʋ���



typedef struct{
	unsigned int state;
	unsigned int bg;
	unsigned int trend;
	unsigned int K;
	unsigned int Backgroud;
}_sConvertResult_t;


//----------------------------------
//      global  function
//----------------------------------
extern void BGC_Init();
extern int BGC_InputCurrent(unsigned int current, _sConvertResult_t *result);
extern int BGC_InputReference(unsigned int ref, int type);
extern int BGC_PermitRef();
extern void BGC_ContinueConverting(unsigned int K, unsigned int background, unsigned int latestcurrent);

extern int BGC_Verion();
