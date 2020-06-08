
/**
 * @author asoocool
 */

function ATickerView()
{
	AView.call(this);
	
	this.tickerArr = null;
	this.childLen = 0;
	this.curOffset = 0;
	this.interVal = null;
	this.isPlayed = false;
	this.dataArr = null;
	this.dataOffset = 0;	//data에 대한 offset
	this.saveDataLength = 10;
	this.sliceCount = 0;
	this.spliceCount = 0;
	
	this.changeTime = 2000;	//전환시간
}
afc.extendsClass(ATickerView, AView);

ATickerView.prototype.init = function(context, evtListener)
{
	AView.prototype.init.call(this, context, evtListener);
	
	this.tickerArr = this.$ele.children();
	this.childLen = this.tickerArr.length;
};

ATickerView.prototype.setChnageTime = function(time)
{
	this.changeTime = time;
};

ATickerView.prototype.setChild = function()
{
	this.tickerArr = this.$ele.children();
	this.childLen = this.tickerArr.length;
};

//ATickerView에 AView가 아닌 다른 컴포넌트들을 셋팅하는 경우
ATickerView.prototype.setAutoView = function()
{
	var acomp, className, thisObj = this;
	var container = this.getContainer(), rootView = this.getRootView();
	var cloneItems = new Array();
	for(var i=0; i<2; i++){
		cloneItems.push(this.$ele.clone(true, true));
		cloneItems[i].attr('data-class', 'AView');
	}

	this.removeChildren();

	for(var i=0; i<2; i++){
		cloneItems[i].css('margin-top', cloneItems[i].height()+'px');
		this.$ele.append(cloneItems[i]);
	}

	this.$ele.children().each(function()
							  {
		className = this.getAttribute(afc.ATTR_CLASS);
		acomp = new window[className]();
		if(acomp) 
		{
			this.container = container;
			this.rootView = rootView;

			//parent 변수만 셋팅해야 하므로 setParent 함수를 호출하지 않는다.
			//acomp.setParent(thisObj);
			acomp.parent = thisObj;

			acomp.init(this);
		}
	});
	cloneItems[0].css('background','red');
	cloneItems[1].css('background','blue');
	
	this.tickerArr = this.$ele.children();
	this.childLen = this.tickerArr.length;
};

ATickerView.prototype.playAnimation = function()
{
	var thisObj = this, prevDom = null, nextDom = null, child;

	this.stopAnimation();
	
	//설정항목이 1개일 경우는 보여주기만 하고 애니메이션 타이머를 돌리지 않는다.
	if(this.childLen == 1)
	{
		//this.tickerArr.eq(0).addClass('slide-in-up');
		return;
	}
	
	this.tickerArr.hide();
	
	this.isPlayed = true;
	//this.tickerArr.eq(thisObj.curOffset).addClass('slide-in-up');
	this.tickerArr.eq(thisObj.curOffset).show();
	
    this.interVal = setInterval(function()
	{
		prevDom = thisObj.tickerArr.eq(thisObj.curOffset);
		//prevDom.removeClass('slide-in-up');
		//prevDom.addClass('slide-out-up');
		
		nextDom = thisObj.tickerArr.eq((thisObj.curOffset+1)%thisObj.childLen);
		//nextDom.addClass('slide-in-up');
		nextDom.show();
		prevDom.hide();
		
		//prevDom.one('webkitAnimationEnd', _after_work);
		
		if(thisObj.curOffset >= (thisObj.childLen - 1)) thisObj.curOffset = 0;
		else thisObj.curOffset++;
		
	}, this.changeTime);
	
	
	function _after_work()
	{
		//$(this).removeClass('slide-out-up');
		$(this).hide();
/*
		if(thisObj.dataArr)
		{
			if(thisObj.spliceCount)
			{
				thisObj.dataArr.splice(thisObj.dataOffset, thisObj.spliceCount);
				thisObj.spliceCount = 0;
			}

			if(thisObj.sliceCount >= thisObj.dataOffset)
			{
				thisObj.dataArr = thisObj.dataArr.slice(thisObj.dataOffset);
				thisObj.sliceCount -= thisObj.dataOffset;
				thisObj.dataOffset = 0;
			}
			else
			{
				thisObj.dataArr = thisObj.dataArr.slice(thisObj.sliceCount);
				thisObj.dataOffset -= thisObj.sliceCount;
				thisObj.sliceCount = 0;
			}

			if(thisObj.dataOffset==thisObj.dataArr.length)	thisObj.stopAnimation();

			if(thisObj.dataArr[thisObj.dataOffset])
			{
				child = thisObj.tickerArr[thisObj.curOffset-1<0?1:0].acomp;
				child.setQueryData([thisObj.dataArr[thisObj.dataOffset++]], thisObj.keyArr);
			}
		}
*/	
	}
	
	
	
};

ATickerView.prototype.stopAnimation = function()
{
	if(this.interVal)
	{
    	clearInterval(this.interVal);
		this.interVal = null;
		this.isPlayed = false;
	}
	//this.tickerArr.removeClass('slide-in-up');
	//this.tickerArr.removeClass('slide-out-up');
};

/*
ATickerView.prototype.getQueryData = function(dataArr, keyArr, queryData)
{	
};

*/
ATickerView.prototype.setQueryData = function(dataArr, keyArr, queryData)
{
	var child, thisObj = this;
	this.keyArr = keyArr;
	
	if(!this.dataArr)
	{
		this.dataArr = new Array();
		for(var i=0; i<dataArr.length; i++)	this.dataArr.push(dataArr[i]);
		this.dataOffset = 0;
	}
	else if(this.dataArr.length >= this.saveDataLength)
	{
		if(this.sliceCount < this.saveDataLength) this.sliceCount++;
		else this.spliceCount++;
		this.dataArr.push(dataArr[0]);
	}
	else	this.dataArr.push(dataArr[0]);
	
	if(this.realMode)
	{
		if(!this.isPlayed)
		{
			child = this.tickerArr[this.curOffset-1<0?1:0].acomp;
			if(this.dataArr[this.dataOffset]) child.setQueryData([this.dataArr[this.dataOffset++]], keyArr, queryData);
			this.playAnimation();
		}
	}
	else
	{
		if(this.dataArr[this.dataOffset])
		{
			child = this.tickerArr[this.curOffset].acomp;
			child.setQueryData([this.dataArr[this.dataOffset++]], keyArr, queryData);
		}
		
		if(this.dataArr.length>1)
		{
			child = this.tickerArr[this.curOffset-1<0?1:0].acomp;
			child.setQueryData([this.dataArr[this.dataOffset++]], keyArr, queryData);
		}
		
		if(!this.isPlayed) this.playAnimation();
		this.realMode = true;
	}
	
	if(this.dataArr.length<2) this.stopAnimation();
};
