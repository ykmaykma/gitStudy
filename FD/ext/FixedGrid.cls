/**
 * @author asoocool
 */

@class FixedGrid()
{
	@super();

    this.offsetRow = 0;
    this.offsetCol = 0;
	this.isAutoReset = true;
// 	this.isColorMode = false;
// 	this.vSignKey = null;
// 	this.colorCellArr = new Array();

	this.isLock = true;
}
@extends StockGrid;

@function FixedGrid:init(context, evtListener)
{
    //AGrid.prototype.init.call(this, context, evtListener);
	@super.init(context, evtListener);
    
    this.resetGrid();
};

@function FixedGrid:resetGrid()
{
    this.removeAll();
    
    this.offsetRow = this.addRow([]).get(0);
    this.offsetCol = 0;
	this.isLock = true;
};

@function FixedGrid:setDataOffset(row, col)
{
    this.offsetRow = this.getRow(row);
    this.offsetCol = col;
};

@function FixedGrid.addToggleRow(toggleRowArr, defaultIdx)
{
	if(!this.toggleRowArr)
	{
		this.toggleRowArr = new Array();
		this.toggleRowOfs = new Array();
	} 
	
    this.toggleRowArr.push(toggleRowArr);
    var lastIdx = this.toggleRowArr.length-1;
    
    this.toggleRowOfs.push((defaultIdx != undefined) ? defaultIdx : 0); 
	
    var rowArr = null;
    for(var i=0; i<this.toggleRowArr[lastIdx].length; i++)
    {
		if(i != this.toggleRowOfs[lastIdx])
		{
			rowArr = this.toggleRowArr[lastIdx][i].split('/');
			for(var j = 0; j<rowArr.length; j++)
			{
				this.tBody.children().eq(rowArr[j]).hide();
			}
		}
    }
};

@function FixedGrid.toggleRow(groupIdx)
{
    var curRowArr = this.toggleRowArr[groupIdx][this.toggleRowOfs[groupIdx]].split('/');
	var bodyTrArr = this.tBody.children();
	
	for(var i = 0; i<curRowArr.length; i++)
	{
		bodyTrArr.eq(curRowArr[i]).hide();
	}
    
    this.toggleRowOfs[groupIdx]++;
    
	if(this.toggleRowArr[groupIdx].length <= this.toggleRowOfs[groupIdx]) this.toggleRowOfs[groupIdx] = 0;
	
	curRowArr = this.toggleRowArr[groupIdx][this.toggleRowOfs[groupIdx]].split('/');
	for(var i = 0; i<curRowArr.length; i++)
	{
		bodyTrArr.eq(curRowArr[i]).show();
	}
};

@function FixedGrid:setAutoReset(isAutoReset)
{
    this.isAutoReset = isAutoReset;
};
/*
FixedGrid.prototype.setColorCellInfo = function(cellArr, vSignKey)
{
	this.isColorMode = true;
    this.colorCellArr = cellArr;
    this.vSignKey = vSignKey;
};
*/

@function FixedGrid:setQueryData(dataArr, keyArr, queryData)
{
	if(!keyArr) return;
	
	if(queryData.isReal)
	{
		if(this.isLock) return;
	}
	else this.isLock = false;
	
	if(this.isAutoReset) this.setDataOffset(0, 0);
    
    var data, keyVal, value, ret, cell;
    
    for(var i=0; i<dataArr.length; i++)
    {
        data = dataArr[i];
		if(queryData.isReal) data = AQueryData.getDataKeyObj(data.key);
        
        for(var j=0; j<keyArr.length; j++)
        {
            keyVal = keyArr[j];
            
            if(this.offsetCol==this.columnCount) 
            {
                this.offsetRow = $(this.offsetRow).next().get(0);
                this.offsetCol = 0;
            }
			
			cell = this.getCell(this.offsetRow, this.offsetCol);
			
			if(!cell) continue;
			
			if(cell.getAttribute('data-span'))
			{
				this.offsetCol++;
				j--;
				continue;
			}
			
			if(keyVal && data[keyVal]!=undefined) 
			{
				if(!queryData.isReal) cell = null;
				
				ret = this.getMaskValue(j, data, keyVal, cell);
				if(ret) this.setCellText(this.offsetRow, this.offsetCol, ret);
			}
			
            this.offsetCol++;
        }
    }
};



@function FixedGrid:getQueryData(dataArr, keyArr, queryData)
{
    if(!keyArr) return;
};

