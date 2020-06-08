
/**
DropBox 두번째 유형
** 계좌콤보에서 선택한 목록을 표시하는 내용과 목록을 다르게 구현
  1. 표시: 상품유형명 + 계좌명
  2. 목록: 상품유형명 + 계좌번호 + 계좌명

> 해당 유형 사용시, 대상 컴포넌트의 스타일을 DR_002로 설정해주어야 함

자동 하단 스크롤 화살표,
리스트 오픈 시 우측 화살표 모양 변경이 적용되어 있음
*/
@class DropBoxType2()
{
	@super();

	//TODO:edit here

}
@extends ADropBox;


@function DropBoxType2:init(context, evtListener)
{
	@super.init(context, evtListener);
	
	this.dropWin = new BaseWindow('_drop_win');
	
	this.dropWin.setWindowOption(
	{
		isModal: true,
		modalBgOption: 'none',
		isFocusLostClose: true
	});
	
	this.dropBoxH = 420;	//400에서 변경 2016.08.25. 황청유
	this.dwScrollHeight = 20;
	this.selectClass = 'BT_025_L_TCH';
	this.normalClass = 'BT_025_L_NOR';
};

@function DropBoxType2:openBox(isButtonClick)
{

	if(this.dropWin.isValid()) return;
	
    var thisObj = this;   
    if(this.getItemSize() < 1) return;
	
	if (this.$ele.hasClass('combo2'))
	{
		this.removeClass('combo2');
		this.addClass('combo2_drop');
	}
	else if (this.$ele.hasClass('combo'))
	{
		this.removeClass('combo');
		this.addClass('combo_drop');
	}
	
	this.addClass('DR_002_U');
	
	var listDiv = $('<div data-base="AView" data-class="AView" data-flag="1011" class="dropboxBack AView-Style" style="height:auto;" ></div>');
	var dwScroll = $('<div><span id="DwScroll" class="BT_015_1_NOR" style="width:100%;height:'+this.dwScrollHeight+'px;border-top:solid 1px #cbcbd3;"></span></div>');
	var dwScroll2 = $('<div><span id="DwScroll" class="BT_015_2_NOR" style="width:100%;height:'+this.dwScrollHeight+'px;border-top:solid 1px #cbcbd3;"></span></div>');
	
	var dwScroll3 = $('<div><span id="DwScroll" class="BT_015_1_NOR" style="width:100%;height:'+this.dwScrollHeight+'px;border-bottom:solid 1px #cbcbd3;"></span></div>');	
	var dwScroll4 = $('<div><span id="DwScroll" class="BT_015_2_NOR" style="width:100%;height:'+this.dwScrollHeight+'px;border-bottom:solid 1px #cbcbd3;"></span></div>');
	
	var ulObj = $('<ul class="dropboxList" style="max-height: '+this.dropBoxH+'px !important;"></ul>');
	listDiv.append(ulObj);
	
	this.scrollArea = ulObj;
	this.enableScrlManagerY();
	
	this.dropWin.url = listDiv;
	this.bindData(ulObj);
	
	var pos = this.$ele.offset();
    var boxHeight = Math.min(70*this.items.length, this.dropBoxH);
	var dropsize = boxHeight;

	if(70*this.items.length - this.dropBoxH > 0) {
		dropsize += this.dwScrollHeight;
		
		ulObj.bind('scroll', function(e)
		{
			if(type) {
				dwScroll.show();
				dwScroll2.hide();
				if(this.offsetHeight + this.scrollTop >= this.scrollHeight)
				{
					dwScroll.hide();
					dwScroll2.show();
				} 
			}else {
				dwScroll3.show();
				dwScroll4.hide();
				if(this.offsetHeight + this.scrollTop >= this.scrollHeight)
				{
					dwScroll3.hide();
					dwScroll4.show();
				}
			}
		});	
	}
	
	var type = true;		//true: 하단 / false: 상단
	//드랍박스를 상단으로 띄울지 하단으로 띄울지 결정
	if((pos.top + dropsize) > $(window).height())
	{
		pos.top -= (dropsize-1);
		type = false;
		//listDiv.addClass('DR_002_DW');
	}
	else
	{
		pos.top += (this.$ele.height() + 1);
		//listDiv.addClass('DR_002_UP');
	}
	
	this.dropWin.open(this, pos.left, pos.top, this.$ele.outerWidth()-4, dropsize);
	this.dropWin.frame.addClass('SHADOW_BOX2');
	
	if(70*this.items.length - this.dropBoxH > 0) {
		
		if(type) {
			this.dropWin.frame.append(dwScroll2);
			this.dropWin.frame.append(dwScroll);


			if(ulObj[0].offsetHeight < ulObj[0].scrollHeight)
			{
				dwScroll.show();
			}
		} else {
			listDiv.css('margin-top', '20px');
			this.dropWin.frame.prepend(dwScroll4);
			this.dropWin.frame.prepend(dwScroll3);
			this.dropWin.frame.removeClass('SHADOW_BOX2');

			dwScroll4.hide();
		}
	}
	if(type) this.dropWin.frame.addClass('DR_002_UP');
	else this.dropWin.frame.addClass('DR_002_DW');
};

@function DropBoxType2:bindData(ulObj)
{
    var dataArr = this.items;
	var acc,
		text = 0;
	
	var w = this.$ele.outerWidth()-20, margin, selEle;
    for(var i=0; i<dataArr.length; i++)
    {
/*		if(i==dataArr.length-1) margin = ' 5px 10px;';
		else margin = ' 5px 10px 10px;';
*/	
		acc = afc.makeAccText(dataArr[i].data);
		text = [dataArr[i].data['D1상품유형명'], ' ', acc, ' ', dataArr[i].data['D1계좌명']].join('');
        var liObjStr = '<li><span class="DR_002_IT B">'+ text +'</span>';
		
        liObjStr += '</li>';
        
        var liObj = $(liObjStr);
        liObj[0].data = dataArr[i];
		liObj[0].index = i;
        ulObj.append(liObj);
        
        this.aevent._select(liObj[0]);
		
		if(this.selIndex == i)
		{
			liObj.addClass(this.selectClass);
			selEle = liObj[0];
		}
		else liObj.addClass(this.normalClass);
		
    }

	if(selEle) this.time = setTimeout(function(){ selEle.scrollIntoView(); });
};

@function DropBoxType2:onWindowResult(result, awindow)
{
	if(this.time)
	{
		clearTimeout(this.time);
		this.time = null;
	}
	this.removeClass('DR_002_U');
	//this.addClass('DR_002_D');
	if(this.getContainer().onWindowResult)
	{
		this.getContainer().onWindowResult(result, awindow);
	}
	
	if (this.$ele.hasClass('combo2_drop'))
	{
		this.removeClass('combo2_drop');
		this.addClass('combo2');
	}
	else if (this.$ele.hasClass('combo_drop'))
	{
		this.removeClass('combo_drop');
		this.addClass('combo');
	}
};



