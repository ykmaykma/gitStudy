
/**
Constructor
Do not call Function in Constructor.
*/
@class ByteCheckView()
{
	@super();

	this.inputMode = null;
	this.textField = null;
	this.clearBtn = null;
	this.byteField = null;

}
@extends AView;


@function ByteCheckView:init(context, evtListener)
{
	@super.init(context, evtListener);
	
	
	var thisObj = this;
	var childArr = this.getChildren();
	
	if(childArr[0].getChildren) {
		this.textField = childArr[0].getChildren()[0];
	} else {
		this.textField = childArr[0];
	}
	//텍스트필드
	
	//this.textField.enableTimerChange(true);
	
	this.textField.addEventListener('focus', this, 'focusTextField');
	this.textField.addEventListener('blur', this, 'blurTextField');
	//20160809, 개발자 배경수 수정
	/*this.textField.bindEvent('keyup', function(e)
	{
		thisObj.changeText();
	});*/
	
	if(afc.andVer<5.0) this.textField.enableTimerChange(true);
	this.textField.addEventListener('change', this, 'changeText');
	
	//클리어 버튼
	this.clearBtn = childArr[1];
	this.clearBtn.addEventListener('click', this, 'clearBtnClick');
	this.clearBtn.show(AComponent.GONE);
	
	if(childArr.length > 2)
	{
		//바이트 표시 라벨
		this.byteField = this.getChildren()[2];
	}
	this.initFunc();

};


@function ByteCheckView:setInputMode(mode)
{
	/*
	A or null:	모두
	E:	영문대소문자만
	N:	숫자만
	H:	한글만
	EN: 영문대소문자+숫자
	ENH:	영문대소문자+숫자+한글
	*/
	
	this.inputMode = mode;
};


@function ByteCheckView:initFunc()
{
	var thisObj = this;
	this.textField.setText = function(value)
	{
		//super class function call
		window[this.className].prototype.setText.call(this, value);
	
		
		//if(thisObj.byteField) thisObj.byteField.setText(Utils.lenByte(value));
		if(thisObj.byteField) thisObj.byteField.setText(value.length
		);

	};
};

@function ByteCheckView:changeText()
{
	var regex = null;
	var text = this.textField.getText();
	
	//text = text.replace(/^\s+|\s+$/g, '');	//앞뒤공백처리	
	text = text.replace(/^\s+/g, '');	//앞공백처리	
	
	//대응처리 START +++++++++++++++++++++++
	if(this.inputMode == 'ENH')
	{
		//regex = /^[a-zA-Z0-9가-힣ㄱ-ㅎㅏ-ㅣ\s\u318D\u119E\u11A2\u2022\u2025a\u00B7\uFE55]+$/;
		//if( !regex.test(text) ) text=text.replace(/[^a-zA-Z0-9가-힣ㄱ-ㅎㅏ-ㅣ\s\u318D\u119E\u11A2\u2022\u2025a\u00B7\uFE55]/g, '');
	}
	//대응처리 END +++++++++++++++++++++++++	
	
	//this.textField.$ele.val(text);
	
	//if(this.byteField) this.byteField.setText(Utils.lenByte(text));
	if(this.byteField) this.byteField.setText(text.length);
	this.checkBtnShowHide(text);
};

@function ByteCheckView:blurTextField(comp, info)
{
	this.clearBtn.show(AComponent.GONE);
};

@function ByteCheckView:focusTextField(comp, info)
{
	if(this.textField.$ele.attr('readonly')) return;
	this.checkBtnShowHide(comp.getText());
};

@function ByteCheckView:checkBtnShowHide(text)
{
	if(text.length > 0)	this.clearBtn.show(AComponent.VISIBLE);
	else this.clearBtn.show(AComponent.GONE);
};

@function ByteCheckView:clearBtnClick(comp, info)
{
	if(this.textField.$ele.attr('readonly')) return;
	this.textField.setText('');
};

