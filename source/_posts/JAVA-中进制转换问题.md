---
title: JAVA 中进制转换问题
date: 2016-09-08 15:18:29
categories: 进制转换
tags:
	- 进制转换
	- 
---
## 各进制之间的转换
*java内部封装的方法，十进制转别的 只需要Integer类中to...*
*转十进制，Integer中的parseInt 或者是 valueOf 方法 二者区别如下： *
 * static int parseInt(String s) 将字符串参数作为有符号的十进制整数进行分析。
 * static Integer valueOf(int i) 返回一个表示指定的 int 值的 Integer 实例。 
 * static Integer valueOf(String s) 返回保持指定的 String 的值的 Integer 对象。
 

	int n1 = 14;
	//十进制转成十六进制：
	Integer.toHexString(n1);
	//十进制转成八进制
	Integer.toOctalString(n1);
	//十进制转成二进制
	Integer.toBinaryString(12);

	//十六进制转成十进制
	Integer.valueOf("FFFF",16).toString();
	//十六进制转成二进制
	Integer.toBinaryString(Integer.valueOf("FFFF",16));
	//十六进制转成八进制
	Integer.toOctalString(Integer.valueOf("FFFF",16));

	//八进制转成十进制
	Integer.valueOf("576",8).toString();
	//八进制转成二进制
	Integer.toBinaryString(Integer.valueOf("23",8));
	//八进制转成十六进制
	Integer.toHexString(Integer.valueOf("23",8));


	//二进制转十进制
	Integer.valueOf("0101",2).toString();
	//二进制转八进制
	Integer.toOctalString(Integer.parseInt("0101", 2));
	//二进制转十六进制
	Integer.toHexString(Integer.parseInt("0101", 2));

 

可以看到其他进制之间相互转换，是先转为10进制，然后再转。

## 十进制转成16内进制
 我自己的，没有用栈

	public static String myBaseString(int num, int base) {
		if (base > 16) {
			throw new RuntimeException("进制数超出范围， base = 16");
		}
		StringBuffer str = new StringBuffer();
		String model = "0123456789ABCDE";
		while (num != 0) {
			str.append(model.charAt(num % base));
			num /= base;
		}
		str = str.reverse();
		return str.toString();
	}
  网上的

	public static String baseString(int num, int base) {
		if (base > 16) {
			throw new RuntimeException("进制数超出范围，base<=16");
		}
		StringBuffer str = new StringBuffer("");
		String digths = "0123456789ABCDEF";
		Stack<Character> s = new Stack<Character>();
		String numStr = num + "";
		boolean isMinus = false;// 判断输入的数是不是负数
		if (numStr.charAt(0) == '-') {
			num = Integer.valueOf(numStr.substring(1));
			isMinus = true;
		}
		while (num != 0) {
			s.push(digths.charAt(num % base));
			num /= base;
		}
		if (isMinus)
			str.append("-");
		while (!s.isEmpty()) {
			str.append(s.pop());
		}
		return str.toString();
	}

## 任意进制间转换
	public static String baseNum(String num, int srcBase, int destBase) {
		if (srcBase == destBase) {
			return num;
		}
		String digths = "0123456789ABCDEF";
		char[] chars = num.toCharArray();
		int len = chars.length;
		if (destBase != 10) {// 目标进制不是十进制 先转化为十进制
			num = baseNum(num, srcBase, 10);
		} else {
			int n = 0;
			for (int i = len - 1; i >= 0; i--) {
				n += digths.indexOf(chars[i]) * Math.pow(srcBase, len - i - 1);
			}
			return n + "";
		}
		return baseString(Integer.valueOf(num), destBase);
	}

## 测试
		int i = 10;
		System.out.println("十进制数 " + i + " 转换成十六进制为 " + Integer.toHexString(i));
		System.out.println("十进制数 " + i + " 转换成八进制为 " + Integer.toOctalString(i));
		System.out.println("十进制数 " + i + " 转换成二进制为 " + Integer.toBinaryString(i));

		String str = "A";
		System.out.println("十六进制数 " + str + " 转换成10进制为 " + Integer.parseInt(str, 16));
		System.out.println("十六进制数 " + str + " 转换成10进制为 " + Integer.valueOf(str, 16));

		str = "12";
		System.out.println("八进制数 " + str + " 转换成10进制为 " + Integer.parseInt(str, 8));
		System.out.println("八进制数 " + str + " 转换成10进制为 " + Integer.valueOf(str, 8));
		str = "1010";
		System.out.println("二进制数 " + str + " 转换成10进制为 " + Integer.parseInt(str, 2));
		System.out.println("二进制数 " + str + " 转换成10进制为 " + Integer.valueOf(str, 2));

		str = "342";
		System.out.println("十进制" + str + " 转换成10进制为" + Integer.parseInt(str, 10));
		System.out.println("十进制" + str + " 转换成10进制为" + Integer.valueOf(str, 10));

		System.out.print("输入待转十进制数");
		Scanner scanner = new Scanner(System.in);
		String a = scanner.nextLine();
		System.out.print("要转的进制");
		String b = scanner.nextLine();
		String c = scanner.nextLine();
		System.out.println(baseString(Integer.valueOf(a), Integer.valueOf(b)));

		// 测试平方的写法
		System.out.println(10 ^ 4);
		System.out.println(Math.pow(10, 4));
		System.out.println((10 ^ 4) == (Math.pow(10, 4)));
		System.out.println(baseNum("1010", 2, 8));

		System.out.println(baseString(10, 16));
		System.out.println(baseString(10, 8));
		System.out.println(baseString(10, 2));
	
