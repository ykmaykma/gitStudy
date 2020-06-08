
/**
Constructor
Do not call Function in Constructor.
*/
@class ScrollToolView()
{
	@super();

	this.toolBar = null;
	this.delegator = null;
}
@extends AView;

@function ScrollToolView:init(context, evtListener)
{
	@super.init(context, evtListener);

	this.toolBar = this.getChildren()[0];

	this.toolBar.enableScrlManagerX();

	this.toolBar.$ele.css('padding-left', '10px');
	this.toolBar.$ele.css('padding-right', '10px');
	
	this.bindScrollEvent();
};

@function ScrollToolView:setDelegator(delegator)
{
	this.delegator = delegator;
};

@function ScrollToolView:bindScrollEvent()
{
	var thisObj = this;
	this.toolBar.element.addEventListener('scroll', function(e){ thisObj.onToolBarScroll(thisObj.toolBar, e); });
	this.toolBar.addEventListener('scrollleft', this, 'onToolBarScrollLeft');
	this.toolBar.addEventListener('scrollright', this, 'onToolBarScrollRight');
};

@function ScrollToolView:onToolBarScroll(comp, info)
{
};

@function ScrollToolView:onToolBarScrollLeft(comp, info)
{
};

@function ScrollToolView:onToolBarScrollRight(comp, info)
{
};

@function ScrollToolView:addBtn(tabId, tabName)
{
	var btn = new AButton();
	if(!tabName) tabName = '　';
	btn.init();
	btn.setBtnStyle([ 'B SD26 tab_nor', 'B SD26 tab_select', 'B SD26 tab_select' ]);
	btn.changeBtnState(-1, AButton.NORMAL);
	btn.element.innerHTML = tabName;
	
	btn.setComponentId(tabId);
	btn.setInlineStyle();
	btn.setStyleObj({'margin-left':'10px', 'margin-right':'10px'});
	btn.setStyle('float', 'left');
	btn.setWidth('');
	btn.setHeight(this.toolBar.getHeight());
	
	btn.addEventListener('click', this, 'onTabBtnClick');

	this.toolBar.addComponent(btn);
	
	return btn;
};

@function ScrollToolView:onTabBtnClick(comp, info)
{
	var delegator = this.delegator ? this.delegator : this.getContainer();
	var rtn = true;
	if(delegator.onTabBtnClick) rtn = delegator.onTabBtnClick(comp, info);
	
	if(rtn != false)
	{
		var w = comp.getPos().left + comp.getWidth() + (comp.$ele.css('padding-left').replace('px', '')*2) + 73 - this.getWidth();
		if(comp.getPos().left <= comp.getWidth())
		{
			var prev = comp.$ele.prev();
			if(prev) this.toolBar.$ele.animate({scrollLeft : this.toolBar.element.scrollLeft + comp.getPos().left - 73 - prev.width()}, 200);
		}
		else if(w > 0)
		{
			var next = comp.$ele.next();
			if(next) this.toolBar.$ele.animate({scrollLeft : this.toolBar.element.scrollLeft + w + next.width()}, 200);
		}
	}
	
	var cnt = this.getContainer(), code, mid;
	if(cnt.itemBoxView && cnt.itemBoxView.itemInfo)
	{
		code = cnt.itemBoxView.itemInfo[0];
		mid = cnt.itemBoxView.itemInfo[2];
	}
	
	//아이폰 툴바에서 안보이는 영역 높이가 줄어드는 버그 대응
	if(afc.isIos)
	{
		this.element.style.visibility = 'hidden';
		var thisObj = this;
		setTimeout(function(){
			thisObj.element.style.visibility = 'visible';
		}, 1);
	}
};

@function ScrollToolView:addConfigBtn(btnId)
{
	var btn = new AButton();
	btn.init();
	btn.setBtnStyle([ 'BT_001_SET_NOR', 'BT_001_SET_TCH', 'BT_001_SET_TCH' ]);
	btn.changeBtnState(-1, AButton.NORMAL);

	btn.setText('　');
	btn.setComponentId(btnId);
	btn.setInlineStyle();

	btn.setWidth(64);
	btn.setHeight(this.toolBar.getHeight());
	btn.addEventListener('click', this, 'onConfigBtnClick');

	this.toolBar.addComponent(btn);
};

@function ScrollToolView:onConfigBtnClick(comp, info)
{
	var delegator = this.delegator ? this.delegator : this.getContainer();
	if(delegator.onConfigBtnClick) delegator.onConfigBtnClick(comp, info);
};

//comp의 위치로 스크롤을 이동시킵니다.
//isHistory 1:pushHistory 2:updateTopHistory. 현재가에서 다른 탭 선택되어있는 상태에서 호가 버튼 클릭시에 사용합니다.
@function ScrollToolView:scrollByCompId(comp, isHistory)
{
	if(!comp) return;
	if(typeof comp == 'string') comp = this.getRootView().findCompById(comp);
	
	var w = comp.getPos().left + comp.getWidth() + (comp.$ele.css('padding-left').replace('px', '')*2) + 73 - this.getWidth();
	if(comp.getPos().left <= comp.getWidth())
	{
		var prev = comp.$ele.prev();
		if(prev) this.toolBar.scrollOffset(comp.getPos().left - 73 - prev.width());
	}
	else if(w > 0)
	{
		var next = comp.$ele.next();
		if(next) this.toolBar.scrollOffset(w + next.width());
	}
	
	if(isHistory)
	{
		var cnt = this.getContainer(), code, mid;
		if(cnt.itemBoxView && cnt.itemBoxView.itemInfo)
		{
			code = cnt.itemBoxView.itemInfo[0];
			mid = cnt.itemBoxView.itemInfo[2];
		}

		if(isHistory > 1) theApp.smartViewInfo.updateTopHistory([cnt.getId(), comp.getComponentId(), comp.getText(), code, mid ]);
		/*
		else theApp.smartViewInfo.pushHistory([cnt.getId(), comp.getComponentId(), comp.getText(), code, mid ]);
		*/
	}
};

//2016/07/08 신경섭
@function ScrollToolView:onLeftScrollActionDown(comp, info)
{
	this.startX = info.changedTouches[0].clientX;
	this.startY = info.changedTouches[0].clientY;
	this.moveX = info.changedTouches[0].clientX;
	this.moveY = info.changedTouches[0].clientY;
	
	var thisObj = this;
	if(this.leftMoveInterval) clearInterval(this.leftMoveInterval);
	this.leftMoveInterval = setInterval(function()
	{
		thisObj.toolBar.scrollOffset(-20);
	}, 100);
};

@function ScrollToolView:onRightScrollActionDown(comp, info)
{
	this.startX = info.changedTouches[0].clientX;
	this.startY = info.changedTouches[0].clientY;
	this.moveX = info.changedTouches[0].clientX;
	this.moveY = info.changedTouches[0].clientY;
	
	var thisObj = this;
	if(this.rightMoveInterval) clearInterval(this.rightMoveInterval);
	this.rightMoveInterval = setInterval(function()
	{
		thisObj.toolBar.scrollOffset(20);
	}, 100);
};

@function ScrollToolView:onLeftScrollActionMove(comp, info)
{
	this.moveX = info.changedTouches[0].clientX;
	this.moveY = info.changedTouches[0].clientY;
	
	if(Math.abs(this.moveX - this.startX) > 20 || Math.abs(this.moveY - this.startY) > 10) 
	{
		if(this.leftMoveInterval) clearInterval(this.leftMoveInterval);
	}
};

@function ScrollToolView:onRightScrollActionMove(comp, info)
{
	this.moveX = info.changedTouches[0].clientX;
	this.moveY = info.changedTouches[0].clientY;
	
	if(Math.abs(this.moveX - this.startX) > 20 || Math.abs(this.moveY - this.startY) > 10) 
	{
		if(this.rightMoveInterval) clearInterval(this.rightMoveInterval);
	}
};

@function ScrollToolView:onLeftScrollActionUp(comp, info)
{
	if(this.leftMoveInterval) clearInterval(this.leftMoveInterval);
};

@function ScrollToolView:onRightScrollActionUp(comp, info)
{
	if(this.rightMoveInterval) clearInterval(this.rightMoveInterval);
};
