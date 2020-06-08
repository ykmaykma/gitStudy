
/**
Constructor
Do not call Function in Constructor.
*/
@class FD1501_L01()
{
	@super();
}
@extends AView;


@function FD1501_L01:init(context, evtListener)
{
	@super.init(context, evtListener);

	this.label1 = this.findCompByGroup('Label1Gr')[0];
	this.url;
	this.text;
	this.delegator = null;
};

@function FD1501_L01:setData(data, delegator)
{
	this.label1.setText(data.text);
	this.text = data.text;
	this.url = data.Url;
	this.zoom = data.zoom;
	this.delegator = delegator;
};

@function FD1501_L01:onButton1Click(comp, info)
{
	//상단항목 이벤트 전달 중지
	info.stopPropagation();
	var win = AWindow.createWindow('FD/window/FD1501_W01.lay','FD1501W01');
	win.setWindowOption
	(
		{
			isModal:true,
			modalBgOption:'none',
		}
	)

	win.titleText = comp.parent.text;
	win.data = comp.parent.url;
	win.urlType = 1;
	win.enableZoom = comp.parent.zoom;
	win.openAsDialog(this);		
};