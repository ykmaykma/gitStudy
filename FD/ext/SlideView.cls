
/**
 * @author extrmk
 */

function SlideView()
{
	AView.call(this);
	
	this.inx = 0;
	this.delegator = null;
	this.moveUnit = 0;
	this.moveSpeed = 100;
}
afc.extendsClass(SlideView, AView);

SlideView.prototype.init = function(context, evtListener)
{
	AView.prototype.init.call(this, context, evtListener);
	
	this.enableScrlManagerX();
	//this.delegator = this.getContainer();
	this.rbManager = new RadioBtnManager(this);
// 	this.eventBind();

	//this.moveUnit = this.getWidth();
};
/*
SlideView.prototype.eventBind = function()
{
	this.addEventListener('scroll', this, '');
};
*/

//function bindData(view, dataArray[i], this);
//function onViewChanged(inx);
SlideView.prototype.setDelegator = function(delegator)
{
	this.delegator = delegator;	
};

SlideView.prototype.setButtonView = function(buttonView)
{
	this.btnView = buttonView;
	
	var children = this.btnView.getChildren();
	
	for(var i=0; i<children.length; i++)
	{
		children[i].addEventListener('click', this, 'onBtnClick');
	}
	this.rbManager.selectButton(children[0]);
};

SlideView.prototype.onBtnClick = function(comp, info)
{
	if(this.rbManager.getSelectButton() == comp) return;
	this.rbManager.selectButton(comp);
	
	var children = this.btnView.getChildren();
	
	//this.$ele.stopAnima();
	for(var i=0; i<children.length; i++)
	{
		if(children[i] == comp)
		{
			this.inx = i;
			this.$ele.animate({scrollLeft : this.moveUnit*i}, this.moveSpeed);
			return;
		}
	}
};

SlideView.prototype.addItem = function(url, dataArray)
{
	if(!this.moveUnit) this.moveUnit = this.getWidth();
	var view = null;
	var w = this.getWidth(), h = this.getHeight(), isCall = (this.delegator && this.delegator.bindData);
	
	for(var i=0; i<dataArray.length; i++)
	{
		view = new AView();
		view.init();
		view.element.container = this.getContainer();
		view.element.rootView = this;
		view.setStyleObj({
			"left": this.getChildren().length*w+'px',
			"top": "0px",
			"width": "100%",
			"height": "100%",
			"background": "transparent"
		});
		
		view.viewLoad(url);
		this.addComponent(view);
		view.updatePosition();

		if(isCall) this.delegator.bindData(view, dataArray[i], this);
	}
};



SlideView.prototype.addDisableManager = function(disableManager)
{
	this.scrlManagerX.addDisableManager(disableManager);
	//같은 객체를 중복해서 추가해도 무시된다.
	disableManager.addDisableManager(this.scrlManagerX);
};

SlideView.prototype.removeAll = function()
{
	this.removeChildren();
	
	//슬라이드뷰 초기화(버튼뷰가 있다면 첫번째 버튼 선택)
	this.inx = 0;
	if(this.btnView) this.rbManager.selectButton(this.btnView.getChildren()[this.inx]);
};

SlideView.prototype.indexOfView = function(view)
{
	var ret = -1;
	this.$ele.children().each(function(inx)
	{
		if(this === view.element)
		{
			ret = inx;
			return false;
		}
	});
    
    return ret;
};

SlideView.prototype.slideTo = function(index)
{
	this.$ele.animate({scrollLeft : this.moveUnit*index}, this.moveSpeed);
	
	if(this.inx!=index)
	{
		this.inx = index;
		
		this.rbManager.selectButton(this.btnView.getChildren()[this.inx]);
		if(this.delegator && this.delegator.onViewChanged) 
			this.delegator.onViewChanged(this.inx, this);
	}
};

SlideView.prototype.slidePrev = function()
{
	if(this.inx==0) this.inx = 1;
	
	this.inx--;
	this.$ele.animate({scrollLeft : this.moveUnit*this.inx}, this.moveSpeed);
	
	this.rbManager.selectButton(this.btnView.getChildren()[this.inx]);
	if(this.delegator && this.delegator.onViewChanged) 
		this.delegator.onViewChanged(this.inx, this);
};

SlideView.prototype.slideNext = function()
{
	if(this.inx+1==this.getChildren().length) this.inx--;
	
	this.inx++;
	this.$ele.animate({scrollLeft : this.moveUnit*this.inx}, this.moveSpeed);
	
	this.rbManager.selectButton(this.btnView.getChildren()[this.inx]);
	if(this.delegator && this.delegator.onViewChanged) 
		this.delegator.onViewChanged(this.inx, this);
};


SlideView.prototype.scrollXImplement = function()
{
	//PC인 경우 자신의 영역 mousedown 과 상관없이 mousemove 가 무조건 발생한다.
	var thisObj = this, isDown = false, scrlArea = this.element;
	
	this.bindEvent(AEvent.ACTION_DOWN, function(e)
	{
		isDown = true;
		
		e.preventDefault();
		thisObj.scrlManagerX.initScroll(e.changedTouches[0].clientX);
	});
	
	this.bindEvent(AEvent.ACTION_MOVE, function(e)
	{
		if(!isDown) return;
		
		e.preventDefault();
		
		thisObj.scrlManagerX.updateScroll(e.changedTouches[0].clientX, function(move)
		{
			scrlArea.scrollLeft += move;
		});
	});
	
	this.bindEvent(AEvent.ACTION_UP, function(e)
	{
		if(!isDown) return;
		isDown = false;

		e.preventDefault();

		thisObj.scrlManagerX.scrollCheck(e.changedTouches[0].clientX, function(move)
		{
			var ratio = Math.abs(this.totDis)/thisObj.moveUnit;
			
//console.log(this.oldDis);
			
			if(ratio<0.2) thisObj.slideTo(thisObj.inx);//20%
			else if(this.totDis<0) thisObj.slidePrev();
			else if(this.totDis>0) thisObj.slideNext();
			else thisObj.slideTo(thisObj.inx);//20%
			
			return false;
		});
	});
};



