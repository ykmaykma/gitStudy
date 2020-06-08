
/**
Constructor
Do not call Function in Constructor.
*/
@class MS1005_W06(containerId)
{
	@super(containerId);
	this.btnText = '확인'; //버튼 글자
}
@extends BaseWindow;


@function MS1005_W06:onReady()
{
	@super.onReady();

	this.msgLbl = this.findCompById('MsgLbl');
	this.btn = this.findCompById('Button2');
	this.securityPw = this.findCompByGroup('XSecureTextField1')[0];
	
	this.msgLbl.$ele.html('<span class="SB" style="color:#323b4c; font-size:24px; line-height:141%">이어하기 시, 기존에 신청한 계좌<br>비밀번호 입력이 필요합니다.</span>');
	this.btn.setText(this.btnText);
};


@function MS1005_W06:onButton2Click(comp, info)
{
	info.stopPropagation();
	if(this.securityPw.getText()) {
		this.close(this.securityPw.getCipherData());
	} else {
		AToast.show('계좌비밀번호를 입력하여 주시기 바랍니다.');
	}
};