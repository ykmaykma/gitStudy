
/**
Constructor
Do not call Function in Constructor.
*/


/*
****************************************
피봇뷰 컴포넌트 순서
****************************************
	EXPivotView
	|--AGrid : 고정그리드
	|--AView(this.scrollView) : 스크롤뷰
	    |--AGrid: 스크롤그리드	
	    |--ALabel : 왼쪽화살표	(자동추가)
		|--ALabel : 오른쪽화살표 (자동추가)
*/


@class ArrowScrollPivotView()
{
	@super();

	//TODO:edit here
	this.lArrow = null;
	this.rArrow = null;
	
	this.checkAlready = false;
	
}
@extends EXPivotView;


@function ArrowScrollPivotView:init(context, evtListener)
{
	@super.init(context, evtListener);
	
	var thisObj = this;
	
	//꼭 내부 이벤트를 타야 하는 것이 아니라면 이렇게 하는 것이 속도상으론 이득이다. 
	AEvent.bindEvent(this.scrollView.element, AEvent.ACTION_DOWN, function(e)
	{
		thisObj.checkAlready = false;
	});

	AEvent.bindEvent(this.scrollView.element, 'scroll', function(e)
	{
		thisObj.doOnPivotViewScroll();
	});
	
	
	this.scrollView.addEventListener('scrollleft', this, 'doOnPivotViewScrollLeft');
	this.scrollView.addEventListener('scrollright', this, 'doOnPivotViewScrollRight');
	
	this.scrollView.$ele.css('overflow', 'hidden');
	
	//화살표 추가
	this.doAddArrows();
	
};

//화살표 추가
@function ArrowScrollPivotView:doAddArrows()
{

	var thead = this.pivotGrid.tHead;
	//헤더로우 갯수
	var hrows = thead.children().length;
	//헤더로우 높이
	var headH = thead.children().eq(0).height();	

	//왼쪽 화살표 생성
	this.lArrow = this.doMakeAddArrow('left', headH*hrows);
	//오른쪽 화살표 생성
	this.rArrow = this.doMakeAddArrow('right', headH*hrows);
	
	//화살표 추가
	this.addComponent(this.lArrow , false);	
	this.addComponent(this.rArrow , false);
	
	if(this.getAttr('view-type') == 'right') var leftSpace = 0;
	else var leftSpace = this.pivotGrid.getWidth();
	
	//왼쪽 화살표 위치 설정
	this.lArrow.setPos({left: leftSpace+10, top:0});
	//오른쪽 화살표 위치 설정
	this.rArrow.setPos({left: leftSpace+(this.scrollView.getWidth()-this.rArrow.getWidth()-10), top:0});
	
	//화살표 초기화	
	if(this.scrollView.getWidth() == this.scrollGrid.getWidth())
	{
		this.lArrow.show(AComponent.INVISIBLE);
		this.rArrow.show(AComponent.INVISIBLE);
	}
	else if(this.scrollView.getWidth() < this.scrollGrid.getWidth())
	{
		this.lArrow.show(AComponent.INVISIBLE);
		this.rArrow.show(AComponent.VISIBLE);
	}
	else 
	{
		this.lArrow.show(AComponent.VISIBLE);
		this.rArrow.show(AComponent.INVISIBLE);
	}
	
};


//화살표 생성
@function ArrowScrollPivotView:doMakeAddArrow(aSide, hSize)
{

	
	var lbl = new ALabel(),
		wSize = 13; //화살표 가로 크기
	lbl.init();
	//lbl.setComponentId(aSide == 'left' ? 'LArrow' : 'RArrow');
	lbl.setText('');
	lbl.setWidth(wSize);
	lbl.setHeight(hSize);	//화살표 세로사이즈는 그리드 헤더 사이즈와 같게 해야 해더 세로 가운데 화살표가 나옴
	
	//왼쪽 화살표
	if(aSide == 'left')
	{
		lbl.addClass('BT_001_P_NOR');
		lbl.setStyleObj({
			'position' : 'absoulte',
			'z-index' : 15 /*그리드 헤더 레이어보다 위에 있어야함*/
		});		
	}
	//오른쪽 화살표
	else
	{
		lbl.addClass('BT_001_N_NOR');
		lbl.setStyleObj({
			'position' : 'absoulte',
			'z-index' : 15 /*그리드 헤더 레이어보다 위에 있어야함*/
		});
	}
	
	return lbl;
	
};


@function ArrowScrollPivotView:doOnPivotViewScroll()
{
	//TODO:edit here
	
	if(!this.checkAlready)
	{
		this.checkAlready = true;

		//왼쪽 스크롤이 가능하면 
		if(this.scrollView.isMoreScrollLeft()) this.lArrow.show(AComponent.VISIBLE);
		else this.lArrow.show(AComponent.INVISIBLE);

		//오른쪽 스크롤이 가능할때
		if(this.scrollView.isMoreScrollRight()) this.rArrow.show(AComponent.VISIBLE);
		else this.rArrow.show(AComponent.INVISIBLE);
	}
};

@function ArrowScrollPivotView:doOnPivotViewScrollLeft(comp, info)
{
	this.lArrow.show(AComponent.INVISIBLE);
	this.rArrow.show(AComponent.VISIBLE);
};

@function ArrowScrollPivotView:doOnPivotViewScrollRight(comp, info)
{
	this.lArrow.show(AComponent.VISIBLE);
	this.rArrow.show(AComponent.INVISIBLE);
};

