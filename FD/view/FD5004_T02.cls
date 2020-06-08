
/**
Constructor
Do not call Function in Constructor.
*/
@class FD5004_T02()
{
	@super();

	//TODO:edit here

}
@extends AView;


@function FD5004_T02:init(context, evtListener)
{
	@super.init(context, evtListener);

	//TODO:edit here
	

};


@function FD5004_T02:onActiveDone(reload)
{
	@super.onActiveDone(reload);			
	
	
};

@function FD5004_T02:onbtnNextClick(comp, info)
{
	theApp.goPageCheck('FD5008', false, {tabId:'FD5008_T01'});
	
};
