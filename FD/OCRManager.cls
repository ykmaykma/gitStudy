
/**
Constructor
Do not call Function in Constructor.
*/
var OCRManager = {};

OCRManager.callbackFunc = null;

OCRManager.RESLT_CANCELED = 0;
OCRManager.CONTINUE_STEP = 1;
OCRManager.RESULT_SUCCESS = 2;
OCRManager.RESULT_FAILE = 3;


//step이 0인경우는 촬영단계에서 백버튼을 클릭 한 경우이다
//step이 1일경우 콜백함수를 null처리 하지 않고 이미지처리 완료 후 콜백함수가 다시 한번 발생한다
OCRManager.OCRWorkDone = function(step, text, image)
{
	if(OCRManager.callbackFunc != null) {
		OCRManager.callbackFunc(step, text, image);
	}
	if(step != OCRManager.CONTINUE_STEP) OCRManager.callbackFunc = null;
};

OCRManager.functionCheck = function(callback)
{
	//callbackFunc
	if(OCRManager.callbackFunc) 
	{
		callback(0);
	}
	OCRManager.callbackFunc = callback;
	return true;
};

OCRManager.openOCR = function(callback)
{
	if(OCRManager.functionCheck(callback))
		cordova.exec(null , null, "OCRPlugin" , "openOCR", []);
};
