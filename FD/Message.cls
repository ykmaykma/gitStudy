
var Message = 
{
	'9000': '조회 실패',
	'9001': 'Invalid Join Count',
	'9002': '정의되지 않은 KFID 를 사용',
	'9003': '정의되지 않은 FID 를 사용',
	'9004': 'Invalid Gid Count',
	'9005': '파일을 찾을 수 없습니다.',
	'9006': '해당 데이터가 없습니다.',
	'9010': 'Input Data Invalid',
	
	//체크 DS 에러
	'10000': 'Trans pattern error',
	'10010': 'No data error',
	'10020': 'Key fid error',
	'10030': 'Data id error',
	'10040': 'Code error',
	'10050': 'Data fid error',
	'10060': 'File transfer error',
	'10070': 'AL serer login error',
	'10080': 'Server system error',
	'10090': 'Screen error',
	'10100': 'authority error',
	'10090': '종목검색창 No data error(잔존)',
	'10091': '종목검색창 No data error(이름)',
	'10092': '종목검색창 No data error(조건)',
	'13001': '미등록 CLIENT',
	'20150': 'TR code register error',
	'19000': '종목코드 최대갯수 초과',

	'LastList': '마지막 목록입니다',
	'NoneList': '조회내역이 없습니다',
	
	'AM0001': '조회기간시작일이 조회기간마지막일보다 큽니다',
	'AM0002': '조회기간마지막일이 조회기간시작일보다 작습니다'
};

//or Message['10000']; or Message.Hello;
Message.getMessage = function(code)
{
	var msg = Message[code];
	
	if(msg) return msg;
	else return 'no message';
};