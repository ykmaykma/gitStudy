
/**
Constructor
Do not call Function in Constructor.
*/
function DnDListView()
{
	AListView.call(this);
	
	this.dragInx = -1;
	this.direction = DDManager.DIR_VERTICAL;
	this.normalClass	= '';
	this.dragClass		= '';
}
afc.extendsClass(DnDListView, AListView);


DnDListView.prototype.init = function(context, evtListener)
{
	AListView.prototype.init.call(this, context, evtListener);

	this.enableDrop(true);	//드랍 가능 상태로 만듬
	
	this.addEventListener('drop', this, 'onListViewDrop');		//리스트뷰 위에 드랍
	
};

DnDListView.prototype.createItems = function(url, dataArray, isPrepend)
{
	var newItems = AListView.prototype.createItems.call(this, url, dataArray, isPrepend);
	
	var thisObj = this;
	$(newItems).each(function()
	{
		this.view.enableDrop(true);
		
		this.view.addEventListener('longtab', thisObj, 'onViewLongTab');
		this.view.addEventListener('drop', thisObj, 'onViewDrop');
	});
	
	return newItems;
};

DnDListView.prototype.getDragInx = function()
{
	return this.dragInx;
};

DnDListView.prototype.setDirection = function(direction)
{
	this.direction = direction;
};

DnDListView.prototype.onViewLongTab = function(comp, info)
{
	this.aevent.isTouchLeave = true;
	
	this.dragInx = this.indexOfItem(comp.item);
	
	this.applyLongTabStyle(comp, info);
	
	$(comp.item).css('position', 'relative');
	
	comp.enableDrag(true);
	comp.ddManager.setDDOption({direction:this.direction});
	comp.ddManager.setDragBound(this.getBoundRect());
};

DnDListView.prototype.applyLongTabStyle = function(comp, info)
{

};

//item drop
DnDListView.prototype.onViewDrop = function(comp, info)
{
	//this.aevent.isTouchLeave = true;
	info.dropComp.enableDrag(false);
	$(info.dropComp.item).css('position', 'static');

	this.applyDropStyle(comp, info);
	
	this.itemInsertManage(info.dropComp.item, comp.item, true);
	if(this.delegator && this.delegator.onItemChanged) this.delegator.onItemChanged(info.dropComp.item, this);
};

DnDListView.prototype.applyDropStyle = function(comp, info)
{
};

//listview drop
DnDListView.prototype.onListViewDrop = function(comp, info)
{
	//this.aevent.isTouchLeave = true;
	info.dropComp.enableDrag(false);
	$(info.dropComp.item).css('position', 'static');
	
	this.applyDropStyle(comp, info);
	
	//맨 뒤에 추가
	this.itemInsertManage(info.dropComp.item);
	
	if(this.delegator && this.delegator.onItemChanged) this.delegator.onItemChanged(info.dropComp.item, this);
};

//----------------------------------------------------------
//  delegate functions
//  function onItemChanged(changeItem, alistview);
//----------------------------------------------------------
