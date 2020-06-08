
/**
Constructor
Do not call Function in Constructor.
*/
@class QuickToolbar()
{
	@super();

	this.framePage = null;
	this.trashWin = null;
	this.homeBtn = null;
	this.quickBntCount = 0;
	this.menusetIdx = null; //현재 설정된 세트메뉴 번호
}
@extends AToolBar;


@function QuickToolbar:init(context, evtListener)
{
	@super.init(context, evtListener);

	this.enableDrop(true);	//드랍 가능 상태로 만듬
	
	//툴바에 직접 드랍할 경우 처리
	this.addEventListener('drop', this, 'onQuickMenuBarDrop');
	
};

@function QuickToolbar:initQuickToolbar(framePage)
{
	this.framePage = framePage;
	this.trashWin = new AWindow.createWindow('FD/window/FD0000_W01.lay', 'FD000001');
	this.trashWin.setWindowOption({ modalBgOption: 'none' });
	this.loadSetMenuInfo(theApp.menuInfo.getUseMenuSet());
};


//세트메뉴 버튼 세팅
@function QuickToolbar:loadSetMenuInfo(menusetIdx)
{
	var me = this, menuItems = null; //현재 설정된 메뉴셋
	
	if(theApp.menuInfo.getMenuSet(menusetIdx))
		menuItems = theApp.menuInfo.getMenuSet(menusetIdx).item; //현재 설정된 메뉴셋
		
	me.removeChildren();
	if(menuItems)
	{
		for(var menuItem=0; menuItem < menuItems.length; menuItem++)
		{	
			if(theApp.menuInfo.isRegPage(menuItems[menuItem]))
			{
				//버튼추가
				me.addComponent(			
					me.makeQuickButton({name:theApp.menuInfo.getPageName(menuItems[menuItem]), pid:menuItems[menuItem]})
				);
			}
			else
			{
				menuItems.splice(menuItem, 1);
				menuItem--;
			}
		}
	}
	this.menusetIdx = menusetIdx;
};

//하단 즐겨찾기 툴바 버튼 셋팅 
@function QuickToolbar:makeQuickButton(info)
{
	var btn = new AButton();

	btn.init();
	btn.setBtnStyle(['KSZ23 BT_043_NOR B', 'KSZ23 BT_043_TCH B', 'KSZ23 BT_043_NOR B']);
	btn.changeBtnState(-1, AButton.NORMAL);
	
	//툴바 내부에 있던 버튼인지ㅁㅇㅇ
	btn.innerBtn = true;
	
	btn.setInlineStyle();
	btn.setWidth(92);
	
	var btnText = info.name;
	if(btnText.length <= 3)
	{	
		//글자수 3글자 이하일 시 addComponent에 문제 발생 > Component 함수 단에서 수정이 필요함
		btnText = btnText + '<br><span style="opacity:0">1</span>';
	}
	else if(btnText.length == 4)
	{
		btnText = btnText.substring(0,2)+'<br>'+btnText.substring(2,4);
	}
	else if(btnText.length == 5)
	{
		var splitPos = 3;
		var exceptionList = ['주식현재가', '신주인수권', '종목토론방', '이체서비스', '투자캘린더'];
		if($.inArray(btnText, exceptionList) > -1 ) splitPos = 2;
		btnText = btnText.substring(0,splitPos)+'<br>'+btnText.substring(splitPos,5);		
	}
	else if(btnText.length > 5)
	{
		//Check용
		if(Define.PRJ_TYPE == Define.MC)
		{
			var splitPos = 3;
			var exceptionList2 = ['KOTC현재가', '주식선물현재가', '상품선물현재가', '최종호가수익률', '프로그램매매'];
			var exceptionList3 = ['선물비교차트', '옵션비교차트', '장내국채호가', '해외비교차트', '해외멀티차트'];
			if($.inArray(btnText, exceptionList2) > -1 ) splitPos = 4;
			else if($.inArray(btnText, exceptionList3) > -1 ) splitPos = 2;
			
			if(btnText.indexOf('\/') > -1) splitPos = btnText.indexOf('\/');

			btnText = btnText.substring(0,splitPos)+'<br>'+btnText.substring(splitPos,btnText.length);			
		}
		else 
		{
			var splitPos = 3;
			if(btnText == 'KOTC현재가') splitPos = 4;
			
			//ex. 신고가/신저가
			if(btnText.indexOf('\/') > -1) splitPos = btnText.indexOf('\/');

			btnText = btnText.substring(0,splitPos)+'<br>'+btnText.substring(splitPos,btnText.length);		
		}
	}
		
	btn.$ele.html(btnText);
	//btn.setText(info.name);
	btn.setAttr('data-pid', info.pid);
	
	btn.addEventListener('click', this, 'onButtonGoPage');		//페이지 이동 처리	
	btn.addEventListener('drop', this, 'onQuickBtnDrop');		//자신위에 드랍시 버튼 삽입 처리
	//자신에게 드랍 가능하도록
	btn.enableDrop(true);			
	btn.addEventListener('longtab', this, 'onQuickBtnLongTab');	//롱탭시 드래그 가능 처리		
	btn.addEventListener('dragEnd', this, 'onQuickBtnDragEnd');	//드래그 종료시 버튼 제거 처리
	
	return btn;
};



//페이지 이동 처리
@function QuickToolbar:onButtonGoPage(comp, info)
{
	if(this.framePage.menuWin && this.framePage.menuWin.isShow())
	{
		this.framePage.menuWin.doHide();
	}
	
	theApp.goPageCheck(comp.getAttr('data-pid'));
	
};



//롱탭시 드래그 가능 처리
@function QuickToolbar:onQuickBtnLongTab(comp, info)
{
	this.trashWin.close();
	this.trashWin.open(this, 0, 0, '100%', '100%');
	
	//-----------------------------------------------
	//	원본을 이동시키킨다.
	var touchs = info.targetTouches[0];
	
	$('body').append(comp.element);
	
	var compW = comp.getWidth()/2, compH = comp.getHeight()/2;
	comp.setStyleObj(
	{
		position:'absolute',
		left:(touchs.clientX-compW)+'px', 
		top:(touchs.clientY-compH)+'px',	
		'background-color':'#efefef',
		'z-index':20000
	}); 
	
	comp.enableDrag(true);
	comp.ddManager.setDragBound({left:78+compW, top:compH, right:$(window).width()-compW-78, bottom:$(window).height()-compH});
	
};


//드래그 종료시 버튼 제거 처리
@function QuickToolbar:onQuickBtnDragEnd(comp, info)
{
	this.trashWin.close();
	//유효한 영역에 드랍되지 않으면 삭제
	if(!comp.isDropped) 
	{
		comp.enableDrag(false);
		comp.removeFromView();
		//this.doSaveMenuSetInfo();
	}
	comp.isDropped = false;
};


@function QuickToolbar:doSaveMenuSetInfo()
{
	
	var bottomMenuSetArr = [];
	var menuBtns = this.getChildren();
	
	for(var i=0; i<menuBtns.length; i++)
	{
		bottomMenuSetArr.push(menuBtns[i].getAttr('data-pid'));
	}
		
	var	menuSetInfo = theApp.menuInfo.getMenuSet(this.menusetIdx);
	menuSetInfo.item.length = 0;
	menuSetInfo.item = bottomMenuSetArr.slice();
	
	//메뉴세트 저장
	theApp.menuInfo.saveInfo();
	
	//전체메뉴window가 있을 경우
	if(this.framePage.menuWin && this.framePage.menuWin.isOpen())
	{
		this.framePage.menuWin.doReloadMenuSet();
	}
	
};


//버튼위에 드랍시 드래그된 버튼 삽입 처리
@function QuickToolbar:onQuickBtnDrop(comp, info)
{
	//자신에게 드랍된 버튼을 자신 앞에 추가
	this.dropManage(info.dropComp, comp, true);
};

//툴바의 빈 공간에 드랍된 경우
@function QuickToolbar:onQuickMenuBarDrop(comp, info)
{
	//맨 뒤에 추가
	this.dropManage(info.dropComp);
};

@function QuickToolbar:dropManage(dropComp, posComp, isPrepend)
{
	dropComp.enableDrag(false);
	
	//현재 아이템 갯수를 구한다. 24개까지만 추가 가능		
	if(24 <= this.$ele.children().length)
	{
		AToast.show('메뉴는 최대 24개까지 선택할 수 있습니다.');
		return;
	}
	
	var pid = dropComp.getAttr('data-pid');
	
	if(!dropComp.innerBtn && this.searchBtn(pid)!=null)
	{
		AToast.show('이미 추가된 항목입니다.');
		return;
	}
	
	//드랍 플래그를 셋팅하여 버튼이 제거되지 않도록 함.
	dropComp.isDropped = true;
	
	//툴바 안에 있던 버튼의 자리 이동인 경우
	if(dropComp.innerBtn)
	{
		dropComp.$ele.css({left:'0px', top:'0px'});
		dropComp.setInlineStyle();
	}
	else
	{
		var info = {name:dropComp.getText(), 'pid': pid};		
		if(dropComp) dropComp.removeFromView();
		dropComp = this.makeQuickButton(info);
	}
	
	dropComp.changeBtnState(AButton.TOUCH, AButton.NORMAL);
	
	this.addComponent(dropComp, isPrepend, posComp);
	
	this.doSaveMenuSetInfo();
	
};


@function QuickToolbar:searchBtn(pid)
{
	var returnValue = null, children = this.getChildren();
	
	for(var i=0; i<children.length; i++)
	{
		if(children[i].getAttr('data-pid')==pid){
			returnValue = children[i];
			break;
		}
	}
	
	return returnValue;
	
};