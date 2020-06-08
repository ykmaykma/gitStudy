/**
 * @author asoocool
 */

function newPieChart()
{
    ACanvas.call(this);
    
	this.ctx = null;
	this.centerX = 0;
	this.centerY = 0;
	this.lineColor = '#202023';
	this.tempColor = '#ffffff';
	this.colorBackground = 'transparent';
	this.rateColor = [ '#f34c60', '#76cdc4', '#f59a28', '#d24cf3', '#c9ca31', '#4b4b84', '#32a55e', '#aab2ba' ]; //색상 배열
		
}
afc.extendsClass(newPieChart, ACanvas);

newPieChart.prototype.init = function(context, evtListener)
{
    ACanvas.prototype.init.call(this, context, evtListener);    
};

newPieChart.prototype.setChartColor = function(arr)
{
	this.rateColor = arr;
};

newPieChart.prototype.RGB2Color = function(r, g, b)
{
	return '#' + byte2Hex(r) + byte2Hex(g) + byte2Hex(b);
};

newPieChart.prototype.byte2Hex = function(n)
{
	var hexString = "0123456789ABCDEF";
	return String(hexString.substr((n >> 4) & 0x0F, 1)) + hexString.substr(n & 0x0F, 1);
};

newPieChart.prototype.draw = function(paramData)
{
	var arr = paramData;
	
	/*ex)
	arr = [{'name':'펀드','data':5},
			{'name':'채권','data':40},
			{'name':'선물옵션','data':50},
			{'name':'주식','data':60}]; 
	*/
	var ctx = this.ctx;
	var centerX = this.centerX;
	var centerY = this.centerY;
	var lastend = Math.PI*1.5-0.001;	//0도부터 시작
	//var lastend = 0;
	var myTotal = 0;
	var myColor = this.rateColor;
	var oneData = null;
	var rateData = 0;
	
	this.element.width = this.canW; 
    this.element.height = this.canH;
	
	for(var e = 0; e < arr.length; e++)
	{
	  	myTotal += arr[e].data;
	}
	
	ctx.strokeStyle = this.lineColor;
	ctx.lineWidth = 4;
	
	if(myTotal > 0)
	{
		for (var i = 0; i < arr.length; i++) 
		{
			oneData = arr[i].data;
			if(oneData)
			{
				rateData = oneData/myTotal;
				ctx.fillStyle = myColor[i];
				ctx.beginPath();
				if(rateData != 1) ctx.moveTo(centerX, centerY);
				ctx.arc(centerX, centerY, centerY-2, lastend, lastend + Math.PI*2*(rateData), false);
				ctx.fill();
				
				if(rateData != 1) ctx.lineTo(centerX, centerY);
				//ctx.stroke();
				lastend += Math.PI*2*(rateData);
				
				
			}
		}	
	}
	else
	{
		ctx.fillStyle = this.tempColor;
		ctx.arc(centerX, centerY, centerY-2, 0, Math.PI*2, false);		
		ctx.stroke();
	}
	
	
	if(myTotal > 0)
	{
		for (var i = 0; i < arr.length; i++) 
		{
			oneData = arr[i].data;
			if(oneData)
			{
				rateData = oneData/myTotal;
				
				if(rateData != 1) ctx.moveTo(centerX, centerY);
				
				var radius = centerY/1.5;
				var lastAngle = lastend + (Math.PI*(arr[i].data/myTotal));
				var setX = centerX + (Math.cos(lastAngle) * radius);
				var setY = centerY + (Math.sin(lastAngle) * radius);
				
				ctx.fillStyle = "#ffffff";
				ctx.font = "18px Arial";
				
				//ctx.fillText(arr[i].name,setX-10,setY);
				if(arr[i].data > 5) ctx.fillText(afc.floorPer(arr[i].data,1),setX-15,setY);

				if(rateData != 1) ctx.lineTo(centerX, centerY);
				//ctx.stroke();
				lastend += Math.PI*2*(rateData);
				
				
			}
		}	
	}	
	
};


