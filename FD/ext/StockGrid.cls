
/**
Constructor
Do not call Function in Constructor.
*/
@class StockGrid()
{
	@super();

	this.colorArr = [];
	this.colorArg = [];
	
}
@extends AGrid;

/*
A : 매핑된 값
B : setColorInfo에서 넣은 key에 맞는 값
					0: 색,X						1: A,0 비교색					2: A,B 비교색				3: A 상태값 색				 	4: A 상태 삼각형 및 색
					5: B,0 비교색	 			  6: A,0 비교 배경색상			7: A,0 비교 삼각형+색상	 8: A,0-상승 1-하락 색상			9: 상승색
					10: 하락색					  11: B 매수-상승 매도-하락 색상    12: 배경라벨125			13:B 등락구분에 맞는 삼각형+색상   14: A,B 비교색(어두운배경) 
					15: B 등락구분에 맞는 예,외*/
StockGrid.COLOR = [	stk.getAsMaskedIt, 			stk.getColorTagCfZero,		stk.getColorTagCfValue,		stk.getColorTagCfState,			stk.getStockTriangle,
					stk.getColorTagValueCfZero, stk.getBgColorTagCfZero,	stk.getTriAndColorTag,		stk.getColorTagCfOrderType,		stk.getUpColorTag,
					stk.getDownColorTag,		stk.getColorTagCfOrderText, stk.getBgColorTagCfZero125,	stk.getTriAndColorTagByState,	stk.getColorTagCfValue_D,
					stk.getPrdtOvtmTextByState];

@function StockGrid:init(context, evtListener)
{
	@super.init(context, evtListener);
	
	 this.loadColorInfo();
};

@function StockGrid:loadColorInfo()
{
	var colorInfo = [];
	for(var i=0; i<this.rowTemplate.length; i++)
	{
		for(var j=0; j<this.columnCount; j++)
		{
			if( $(this.getCell(i, j)).attr('data-span') ) continue;
			colorInfo.push(0);
		}
	}
	
	this.setColorInfo(colorInfo);
	//var colorInfo = this.getAttr(afc.ATTR_COLOR);
	//if(colorInfo) this.setColorInfo(colorInfo.split(','));
};
/*
@function StockGrid:setMaskInfo(arr)
{
	AGrid.prototype.setMaskInfo.call(this, arr);
	
	if(this.colorArr.length == 0)
	{
		for(var i=0; i<arr.length; i++)
		{
			this.colorArr[i] = stk.getAsMaskedIt;
			this.colorArg[i] = [''];
		}
	}
};
*/
@function StockGrid:setColorInfo(arr, noOverride)
{
	if(!noOverride) this.setCellText = this.setCellTag;
	
	var temp;
	for(var i=0; i<arr.length; i++)
	{
		if(typeof(arr[i]) == 'function')
		{
			this.colorArr[i] = arr[i];
			this.colorArg[i] = [];
		}
		else
		{
			temp = arr[i].toString().split('|');

			if(temp[0]!='')
			{
				if(StockGrid.COLOR[temp[0]]) this.colorArr[i] = StockGrid.COLOR[temp[0]];
				else this.colorArr[i] = eval(temp[0]);
			}
			else this.colorArr[i] = stk.getAsMaskedIt;

			temp.shift();
			this.colorArg[i] = temp;
		}
	}
	/*
	if(this.maskArr.length == 0)
	{
		for(var i=0; i<arr.length; i++)
			this.maskArr[i] = afc.returnAsIt;
	}
	*/
	//this.changeSetQueryData();
};

@function StockGrid:resetColorInfo()
{
	this.colorArr = [];
	this.colorArg = [];
	
	//this.changeSetQueryData();
};

/*
@function StockGrid:changeSetQueryData()
{
	if(this.colorArr.length>0) this.setQueryData = this.colorQueryData;
	else if(this.maskArr.length>0) this.setQueryData = this.maskQueryData;
 	else this.setQueryData = this.baseQueryData;
};
*/

@function StockGrid:getMaskValue(index, data, keyVal, ele)
{
	if(this.colorArg[index].length>1) return this.colorArr[index]( data, this.colorArg[index], ele );
	else return this.colorArr[index]( data[keyVal], this.maskArr[index], data[this.colorArg[index][0]], ele );
};

/*
@function StockGrid:colorQueryData(dataArr, keyArr, queryData)
{
	if(!keyArr) return;
	
	var data, row, keyVal, arr;
	
	if(queryData.isReal)
	{
		data = dataArr[0];
		
		//update
		if(this.updateType==0)
		{
			row = this.realMap[data.key];
			for(var j=0; j<keyArr.length; j++)
			{
				keyVal = keyArr[j];
				
				if(this.colorArg[j].length > 1)
				{
					this.setCellTag(row, j, this.colorArr[j]( data, this.colorArg[j] ));
					continue;
				}
				
				if(keyVal && data[keyVal] != undefined)
					this.setCellTag(row, j, this.colorArr[j]( data[keyVal], this.maskArr[j], data[this.colorArg[j][0]] ));
				
				//if(keyVal && data[keyVal] != undefined)
				//{
				//	if(this.colorArg[j].length > 1) this.setCellTag(row, j, this.colorArr[j]( data[keyVal], this.maskArr[j], data, this.colorArg[j] ));
				//	else this.setCellTag(row, j, this.colorArr[j]( data[keyVal], this.maskArr[j], data[this.colorArg[j][0]] ));
				//}
			}
		}
		
		//insert
		else
		{
			var dataObj = AQueryData.getDataKeyObj(data.key);

			arr = new Array(keyArr.length);
			for(var j=0; j<keyArr.length; j++)
			{
				keyVal = keyArr[j];
				
				if(this.colorArg[j].length > 1)
				{
					arr[j] = this.colorArr[j]( dataObj, this.colorArg[j] );
					continue;
				}
				
				if(keyVal) arr[j] =this.colorArr[j]( dataObj[keyVal], this.maskArr[j], dataObj[this.colorArg[j][0]] );
				else arr[j] = '';
			}
			
			//prepend
			if(this.updateType==-1) row = this.prependRow(arr);
			//append
			else if(this.updateType==1) row = this.addRow(arr);
			
			//this.applyBackupScroll();
		}
		if(this.includeData) row.get(0).oridata = data;
	}
	else
	{
		//insert 는 리얼맵을 만들지 않는다.
		if(this.updateType!=0) this.realMap = null;

		for(var i=0; i<dataArr.length; i++)
		{
			data = dataArr[i];
			arr = new Array(keyArr.length);
			
			for(var j=0; j<keyArr.length; j++)
			{
				keyVal = keyArr[j];
				
				if(this.colorArg[j].length > 1)
				{
					arr[j] = this.colorArr[j]( data, this.colorArg[j] );
					continue;
				}
				
				if(keyVal) arr[j] = this.colorArr[j]( data[keyVal], this.maskArr[j], data[this.colorArg[j][0]] );
				else arr[j] = '';
			}
			
			row = this.addRow(arr);
			if(this.includeData) row.get(0).oridata = data;
			
			//리얼맵 생성 중...
			if(this.realMap) 
			{
				//this.realMap[data.key] = row;
				if(!this.realMap[data.key]) this.realMap[data.key] = row;
			}
		}
		this.applyBackupScroll();
	}
};
*/