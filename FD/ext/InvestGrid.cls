
/**
Constructor
Do not call Function in Constructor.
*/
@class InvestGrid()
{
	@super();

}
@extends StockGrid;


@function InvestGrid:init(context, evtListener)
{
	@super.init(context, evtListener);

	this.addRow([]);
};

@function InvestGrid:doRealPattern(dataArr, keyArr, queryData)
{
	var data, rowIdx, colIdx, offsetRow, offset, keyIdx, keyVal, arr, cell;
	
	data = dataArr[0];

	//InvestGrid에는 update밖에 존재하지 않는다.
	cell = this.realMap[data.key];
	if(!cell) return;	//리얼맵이 존재하지 않으면 리턴

	rowIdx = this.rowIndexOfCell(cell);		//cell의 rowIdx를 저장한다
	colIdx = this.colIndexOfCell(cell);		//cell의 colIdx를 저장한다

	//템플릿의 row개수만큼 반복
	for(var j=0; j<this.rowTemplate.length; j++)
	{
		keyIdx = j*this.columnCount;	//row의 0번째 col의 위치값(매핑한 key들의 위치)
		keyVal = keyArr[keyIdx];

		offsetRow = rowIdx + j;			//keyVal의 offsetRow를 구한다. real cell의 rowIdx부터 끝까지
		//offset = keyIdx + colIdx; 		//maskArr에서의 함수 위치(만약 모든 그리드의 mask, color함수가 같다면 제거하고 keyIdx사용)
		
		if(keyVal && data[keyVal] != undefined)
		{
			this.setCellTag(offsetRow, colIdx, this.getMaskValue(keyIdx, data, keyVal));
			//this.setCellTag(offsetRow, colIdx, this.getMaskValue(keyIdx, data, keyVal));
		}
	}
	
	if(this.includeData) cell.oridata = data; 
};

@function InvestGrid:doAddPattern(dataArr, keyArr, queryData)
{
	var data, row, keyVal, arr, keyIdx, offset;

	//i는 offsetCol
	for(var i=0; i<dataArr.length; i++)
	{
		data = dataArr[i];

		//템플릿의 row개수만큼 반복
		for(var j=0; j<this.rowTemplate.length; j++)
		{
			keyIdx = j*this.columnCount;	//row의 0번째 col의 위치값(매핑한 key들의 위치)
			keyVal = keyArr[keyIdx];		//해당 위치에 맞는 keyVal
			//offset = keyIdx + i;			//maskArr에서의 함수 위치(만약 그리드의 모든 mask, color함수가 같다면 제거하고 keyIdx사용)

			if(keyVal)
			{
				//StockGrid에서 setColorInfo를 하는 순간 setCellText에 setCellTag의 함수를 대입한다.
				if(data[keyVal] != undefined) this.setCellText(j, i, this.getMaskValue(keyIdx, data, keyVal));
				//if(data[keyVal] != undefined) this.setCellText(j, i, this.getMaskValue(offset, data, keyVal));
			}
		}
		if(this.includeData) this.getCell(0, offsetCol).oridata = data;

		if(this.realMap) 
		{
			//리얼맵에 등록은 최초에 한번만 한다. 그리고 해당 위치의 최상단 cell을 저장한다.
			//if(!this.realMap[data.key]) this.realMap[data.key] = this.getCell(0, i);
			
			if(data.key) 
			{
				if(!this.realMap[data.key]) this.realMap[data.key] = this.getCell(0, i);
			}
			else 
			{
				for(var k=0; k<data.keys.length; k++)
					if(!this.realMap[data.keys[k]]) this.realMap[data.keys[k]] = this.getCell(0, i);
			}
		}
	}
	this.applyBackupScroll();
};

