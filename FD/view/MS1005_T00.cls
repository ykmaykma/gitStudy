

/**
Constructor
Do not call Function in Constructor.
*/
@class MS1005_T00()
{
	@super();

}
@extends AView;


@function MS1005_T00:init(context, evtListener)
{
	@super.init(context, evtListener);
	
	this.informViewgr = this.findCompByGroup('InformViewgr');
	this.initViewPosition();
};

@function MS1005_T00:onActive(reload)
{
	@super.onActive(reload)
	
	this.initViewPosition();
};


@function MS1005_T00:onWillDeactive(reload)
{
	@super.onWillDeactive(reload);
};

@function MS1005_T00:onNextBtnClick(comp, info)
{
	thisObj.getContainer().nextView();
};

@function MS1005_T00:initViewPosition()
{
	for(var a = 0;a<this.informViewgr.length;a++){
		this.informViewgr[a].setStyleObj({'height':'90px'});
	}
};

@function MS1005_T00:onInformViewActionUp(comp, info)
{
	if(this.preSelectView)
	{
		this.preSelectView.setStyleObj({'height':'90px'});
		this.preSelectView.getChildren()[1].show(AComponent.INVISIBLE);
		
		this.preSelectView.getChildren()[0].getChildren()[0].removeClass('BT_13_TCH');
		this.preSelectView.getChildren()[0].getChildren()[0].addClass('BT_13_NOR');
		
		this.preSelectView.getChildren()[0].getChildren()[1].removeClass('font_style_selected');
		this.preSelectView.getChildren()[0].getChildren()[1].addClass('font_style');	
	}
	
	if(this.preSelectView === comp)
	{
		if(this.preSelectView.isOpen)
		{
			comp.setStyleObj({'height':'90px'});
			comp.getChildren()[1].show(AComponent.INVISIBLE);

			comp.getChildren()[0].getChildren()[0].removeClass('BT_13_TCH');
			comp.getChildren()[0].getChildren()[0].addClass('BT_13_NOR');
			
			comp.getChildren()[0].getChildren()[1].removeClass('font_style_selected');
			comp.getChildren()[0].getChildren()[1].addClass('font_style');	
			comp.isOpen = false;
		}
		else
		{
			comp.setStyleObj({'height':'195px'});
			comp.getChildren()[0].getChildren()[0].removeClass('BT_13_NOR');
			comp.getChildren()[0].getChildren()[0].addClass('BT_13_TCH');
			
			comp.getChildren()[0].getChildren()[1].removeClass('font_style');
			comp.getChildren()[0].getChildren()[1].addClass('font_style_selected');
			comp.getChildren()[1].show(AComponent.VISIBLE);
			comp.isOpen = true;
		}
	}
	else
	{
		comp.setStyleObj({'height':'195px'});
		comp.getChildren()[0].getChildren()[0].removeClass('BT_13_NOR');
		comp.getChildren()[0].getChildren()[0].addClass('BT_13_TCH');
		
		comp.getChildren()[0].getChildren()[1].removeClass('font_style');
		comp.getChildren()[0].getChildren()[1].addClass('font_style_selected');
		comp.getChildren()[1].show(AComponent.VISIBLE);
		comp.isOpen = true;
	}
	
	this.preSelectView = comp;
};


