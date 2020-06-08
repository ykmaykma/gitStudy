var newStockColor_BLACK = 
{
	FONT_UP_COLOR: '#ff4f62',					//상승색
	FONT_DOWN_COLOR: '#008bff',				//하락색
	FONT_STEADY_COLOR: '#e4e5ec',				//보합색
	
	BG_UP_COLOR: '#ff4f62',					//상승배경색 
	BG_DOWN_BG_COLOR: '#008bff',				//하락배경색
	BG_STEADY_BG_COLOR: '#5e637d',				//보합배경색
	
	UP_CLASS_NAME: 'CR_003_D',					//상승 클래스
	DOWN_CLASS_NAME: 'CR_004_D',				//하락 클래스
	STEADY_CLASS_NAME: 'CR_006_D',				//보합 클래스	
	
	UP_SPAN_CLASS_NAME: 'LB_017_1',				//상승 배경색 span 클래스
	DOWN_SPAN_CLASS_NAME: 'LB_017_2',			//하락 배경색 span 클래스
	STEADY_SPAN_CLASS_NAME: 'LB_017_3',			//보합 배경색 span 클래스
	
	UP_ARROW_CLASS_NAME: 'up_arrow',			//상한 화살표 
	UP_TRIANGLE_CLASS_NAME: 'up_triangle',		//상승 삼각형
	DOWN_ARROW_CLASS_NAME: 'down_arrow',		//하한 화살표
	DOWN_TRIANGLE_CLASS_NAME: 'down_triangle',	//하락 삼각형
	STEADY_ARROW_CLASS_NAME: 'steady_arrow',		//보합 삼각형
	
	
	// -----------------------------  미니차트 부분 시작 ----------------------------- //
	//미니차트 어두운 컬러 정의
	CHART_BASE_TEXT_COLOR: '#e4e5ec',						//차트 전체 텍스트 색
	CHART_BASE_PRICE_COLOR: '#e4e5ec',					//기준가 금액 텍스트 색
	CHART_LEFT_TEXT_COLOR: '#e4e5ec',					//미니 차트 왼쪽 텍스트 컬러
	CHART_BOTTOM_TEXT_COLOR: '#6f7790',					//미니 차트 하단 텍스트 컬러
	CHART_BACKGROUND_COLOR: '#000000',						//차트 전체 배경 색
	CHART_BACKLINE_COLOR: '#ffffff',					//차트 전체 영역 구분선 색
	CHART_DOT_COLOR: '#ffffff',						//차트 전체 도트 색
	
	CHART_CONT_BACK_COLOR: '#2c304a',					//컨텐츠 배경색
	CHART_CONT_ROUND_COLOR: 'transparent',				//컨텐츠 배경색
	
	CHART_DIV_LINE_COLOR: '#393e60',					//구분선 색
	CHART_BASE_PRICE_LINE_COLOR: '#586094',					//기준가 선 색
	CHART_TIME_LINE_COLOR: '#ffffff',					//타임영역 구분선 색
	
	// -----------------------------  미니차트 부분 끝 ----------------------------- //
	
	FONT_LAST_PRICE_UP_COLOR: '#a91505',				//마지막 현재가 상승색
	FONT_LAST_PRICE_DOWN_COLOR: '#07a3a3',				//마지막 현재가 하락색
	FONT_LAST_PRICE_STEADY_COLOR: '#07a3a3',			//마지막 현재가 보합색

	CHART_MOVING_AVERAGE_5_COLOR : '#F82008',			//이평(5) 색
	CHART_MOVING_AVERAGE_20_COLOR : '#C98607',			//이평(20) 색
	CHART_MOVING_AVERAGE_60_COLOR : '#177E37',			//이평(60) 색
	CHART_OBV_COLOR : '#FD651A',						//OBV색
	CHART_MACD_12_26_COLOR : '#FD651A',					//MACD(12,26) 색
	CHART_SIGNAL_9_COLOR : '#177E37',					//Signal(9) 색
	CHART_SLOW_K_5_3_COLOR : '#FD651A',					//Slow%K(5,3) 색
	CHART_SLOW_D_3_COLOR : '#177E37',					//Slow%D(3) 색
	CHART_FAST_K_5_COLOR : '#FD651A',					//Fast K(5) 색
	CHART_FAST_D_3_COLOR : '#177E37',					//Fast D(3) 색
	CHART_DISPARITY_10_COLOR : '#FD651A',				//이격도(10) 색
	CHART_RSI_12_COLOR : '#FD651A',						//RSI(12)색
	CHART_SIGNAL_COLOR : '#DC00DC',						//Signal색
	CHART_LINE_Color: '#ffffff',						//라인차트 선 색
	CHART_LINE_Gradation_START: '#00ff00',						//라인차트 그라데이션 시작 색 
	CHART_LINE_Gradation_END: 'rgba(0,255,0,0.0)'				//라인차트 그라데이션 끝 색
	
};

var newStockColor_WHITE = 
{
	FONT_UP_COLOR: '#ff3e47',					//상승색
	FONT_DOWN_COLOR: '#007aff',					//하락색
	FONT_STEADY_COLOR: '#22223b',				//보합색
	
	BG_UP_COLOR: '#ff4f62',					//상승배경색 
	BG_DOWN_BG_COLOR: '#008bff',				//하락배경색
	BG_STEADY_BG_COLOR: '#5e637d',				//보합배경색
	
	UP_CLASS_NAME: 'CR_003_B',					//상승 클래스
	DOWN_CLASS_NAME: 'CR_004_B',					//하락 클래스
	STEADY_CLASS_NAME: 'CR_006_B',				//보합 클래스
	
	UP_SPAN_CLASS_NAME: 'LB_017_1',				//상승 배경색 span 클래스
	DOWN_SPAN_CLASS_NAME: 'LB_017_2',			//하락 배경색 span 클래스
	STEADY_SPAN_CLASS_NAME: 'LB_017_3',			//보합 배경색 span 클래스
	
	UP_ARROW_CLASS_NAME: 'up_arrow',				//상한 화살표 
	UP_TRIANGLE_CLASS_NAME: 'up_triangle',		//상승 삼각형
	DOWN_ARROW_CLASS_NAME: 'down_arrow',			//하한 화살표
	DOWN_TRIANGLE_CLASS_NAME: 'down_triangle',	//하락 삼각형
	STEADY_ARROW_CLASS_NAME: 'steady_arrow',		//보합 삼각형	
	
	// -----------------------------  미니차트 부분 시작 ----------------------------- //
	//미니차트 밝은 컬러 정의
	CHART_BASE_TEXT_COLOR: '#000000',						//차트 전체 텍스트 색
	CHART_BASE_PRICE_COLOR: '#ffffff',					//기준가 금액 텍스트 색
	CHART_LEFT_TEXT_COLOR: '#5e637d',					//미니 차트 왼쪽 텍스트 컬러
	CHART_BOTTOM_TEXT_COLOR: '#5e637d',					//미니 차트 하단 텍스트 컬러
	CHART_BACKGROUND_COLOR: '#000000',						//차트 전체 배경 색
	CHART_BACKLINE_COLOR: '#ffffff',					//차트 전체 영역 구분선 색
	CHART_DOT_COLOR: '#ffffff',						//차트 전체 도트 색
	
	CHART_CONT_BACK_COLOR: '#ffffff',					//컨텐츠 배경색
	CHART_CONT_ROUND_COLOR: '#d9dbe5',					//컨텐츠 배경색
	
	CHART_DIV_LINE_COLOR: '#d9dbe5',						//구분선 색
	CHART_BASE_PRICE_LINE_COLOR: '#7a7c8b',					//기준가 선 색
	CHART_TIME_LINE_COLOR: '#ffffff',					//타임영역 구분선 색
	
	// -----------------------------  미니차트 부분 끝 ----------------------------- //
	
	FONT_LAST_PRICE_UP_COLOR: '#a91505',				//마지막 현재가 상승색
	FONT_LAST_PRICE_DOWN_COLOR: '#07a3a3',				//마지막 현재가 하락색
	FONT_LAST_PRICE_STEADY_COLOR: '#07a3a3',			//마지막 현재가 보합색

	CHART_MOVING_AVERAGE_5_COLOR : '#F82008',			//이평(5) 색
	CHART_MOVING_AVERAGE_20_COLOR : '#C98607',			//이평(20) 색
	CHART_MOVING_AVERAGE_60_COLOR : '#177E37',			//이평(60) 색
	CHART_OBV_COLOR : '#FD651A',						//OBV색
	CHART_MACD_12_26_COLOR : '#FD651A',					//MACD(12,26) 색
	CHART_SIGNAL_9_COLOR : '#177E37',					//Signal(9) 색
	CHART_SLOW_K_5_3_COLOR : '#FD651A',					//Slow%K(5,3) 색
	CHART_SLOW_D_3_COLOR : '#177E37',					//Slow%D(3) 색
	CHART_FAST_K_5_COLOR : '#FD651A',					//Fast K(5) 색
	CHART_FAST_D_3_COLOR : '#177E37',					//Fast D(3) 색
	CHART_DISPARITY_10_COLOR : '#FD651A',				//이격도(10) 색
	CHART_RSI_12_COLOR : '#FD651A',						//RSI(12)색
	CHART_SIGNAL_COLOR : '#DC00DC',						//Signal색
	CHART_LINE_Color: '#ffffff',						//라인차트 선 색
	CHART_LINE_Gradation_START: '#00ff00',				//라인차트 그라데이션 시작 색 
	CHART_LINE_Gradation_END: 'rgba(0,255,0,0.0)'		//라인차트 그라데이션 끝 색
	
};