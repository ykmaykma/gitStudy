
/**
Constructor
Do not call Function in Constructor.
*/
@class MS1005_T14()
{
	@super();

	this.selectedView = null;
	this.acc1View = null;
	this.acc2View = null;
	this.acc3View = null;
	this.acc4View = null;

}
@extends AView;


@function MS1005_T14:init(context, evtListener)
{
	@super.init(context, evtListener);
	
	this.selectedView = [false, false, false, false];
	this.acc1View = this.findCompById('Acc1View');
	this.acc2View = this.findCompById('Acc2View');
	this.acc3View = this.findCompById('Acc3View');
	this.acc4View = this.findCompById('Acc4View');
};

@function MS1005_T14:onActive(reload)
{
	@super.onActive(reload);
	
	if(reload) {
		theApp.checkCreateDatetime();
	}
};

@function MS1005_T14:selectView(comp, clickTrigger)
{
	switch(comp.getComponentId()) {
		case 'Acc1View':
			this.selectedView[0] = !this.selectedView[0];
			return this.selectedView[0];
		case 'Acc2View':
			this.selectedView[1] = !this.selectedView[1];
			return this.selectedView[1];
		case 'Acc3View':
			this.selectedView[2] = !this.selectedView[2];
			return this.selectedView[2];
		case 'Acc4View':
			this.selectedView[3] = !this.selectedView[3];
			return this.selectedView[3];
		default:
			break;
	}
}

@function MS1005_T14:onAccActionUp(comp, info)
{
	var checkBox = comp.getChildren()[2];
 	checkBox.setCheck(this.selectView(comp));
};

@function MS1005_T14:onButtonGoNext(comp, info)
{
	if(this.selectedView[0]||this.selectedView[1]||this.selectedView[2]||this.selectedView[3])
	{
		theApp.setProductId('주식',this.selectedView[0]);
		theApp.setProductId('CMA',this.selectedView[1]);
		theApp.setProductId('수익증권',this.selectedView[2]);
		theApp.setProductId('선물옵션',this.selectedView[3]);
		this.resetPage();
		thisObj.getContainer().nextView();	
	} else {
		AToast.show('개설할 계좌 종류를 선택해주시기 바랍니다.');
	}
};

@function MS1005_T14:onButtonGoBack(comp, info)
{
	this.resetPage();
	this.getContainer().beforeView();
};

@function MS1005_T14:onCheckBoxClick(comp, info)
{
	this.selectView(comp.getParent().getParent());
};

@function MS1005_T14:resetPage() {
	this.acc1View.getChildren()[2].setCheck(false);
	this.acc2View.getChildren()[2].setCheck(false);
	this.acc3View.getChildren()[2].setCheck(false);
	this.acc4View.getChildren()[2].setCheck(false);
	this.selectedView = [false, false, false, false];
};