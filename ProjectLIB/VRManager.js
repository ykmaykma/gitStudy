
/**
Constructor
Do not call Function in Constructor.
*/
var VRManager = {};

VRManager.callbackFunc = null;

VRManager.RESLT_CANCELED = 0;
VRManager.CONTINUE_STEP = 1;
VRManager.RESULT_SUCCESS = 2;
VRManager.RESULT_FAILE = 3;
VRManager.isBackPressed = false;
VRManager.viewSize = null;

//step이 0인경우는 촬영단계에서 백버튼을 클릭 한 경우이다
//step이 1일경우 콜백함수를 null처리 하지 않고 이미지처리 완료 후 콜백함수가 다시 한번 발생한다
VRManager.VRWorkDone = function(step, filePath)
{
	if(VRManager.callbackFunc != null) {
		VRManager.callbackFunc(step, filePath);
	}
	VRManager.callbackFunc = null;
};

VRManager.functionCheck = function(callback)
{
	//callbackFunc
	/*if(VRManager.callbackFunc) 
	{
		callback(0);
	}*/
	VRManager.callbackFunc = callback;
	return true;
};

/*Setting GetVideoFile Callback*/
VRManager.getVideoDone = function(videofile)
{
    if(VRManager.getVideoCallbackFunc != null) {
        VRManager.getVideoCallbackFunc(videofile);
    }
    VRManager.getVideoCallbackFunc = null;
};

VRManager.functionCheck2 = function(callback)
{
    //callbackFunc
    /*if(VRManager.callbackFunc)
     {
     callback(0);
     }*/
    VRManager.getVideoCallbackFunc = callback;
    return true;
};
/*Setting GetVideoFile Callback*/

VRManager.startVR = function(number1, number2, number3, number4, time, quality, callback)
{
	if(VRManager.functionCheck(callback))
		cordova.exec(null , null, "VRPlugin" , "startVR", [number1,number2,number3,number4,time,'VRTest',quality]);
};

VRManager.showRP = function(ele)
{
	VRManager.viewSize = ele;
	var docWidth = $(document).width();
	var docHeight = $(document).height();

	var leftRate = parseInt(ele.offset().left)/docWidth;
	var topRate = parseInt(ele.offset().top)/docHeight;
	var widthRate = ele.width()/docWidth;
	var heightRate = ele.height()/docHeight;

	var params = [leftRate,
				  topRate,
				  widthRate,
				  heightRate,
				  ele[0].id
				 ];
	cordova.exec(null, null, "VRPlugin", "showRP", params);
};

VRManager.endRP = function()
{
	cordova.exec(null, null, "VRPlugin", "endRP", []);
};

VRManager.getVideoFile = function (filePath, callback)
{
    if ( VRManager.functionCheck2(callback))
    {
        cordova.exec(null, null, "VRPlugin", "getVideoFile", [filePath]);
    }
};

VRManager.deleteVideoFile = function (filePath)
{
	if (afc.isAndroid) {
		cordova.exec(null, null, "VRPlugin", "deleteVideoFile", [filePath]);
	}
};


VRManager.onMyBackPressed = function(result)
{
	if(result == 1) {
		VRManager.isBackPressed = true;
	}
};