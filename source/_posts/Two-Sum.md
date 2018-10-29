---
title: Two Sum
date: 2016-09-06 21:41:11
categories:
tags:
	- Leecode
---

Given an array of integers, return indices of the **two numbers** such that they a**dd up to** a specific **target**.

You may assume that each input would have exactly one solution.

Example:
		Given nums = [2, 7, 11, 15], target = 9,
		
		Because nums[0] + nums[1] = 2 + 7 = 9,
		return [0, 1].

----------

### Solution:
1.俩层遍历 暴力穷举
时间复杂度 O(N2)
空间复杂度 O(1)

	public static int[] twoSum(int[] nums, int target) {
	    for (int i = 0; i < nums.length; i++) {
	        for (int j = i + 1; j < nums.length; j++) {
	            if (nums[j] == target - nums[i]) {
	                return new int[] { i, j };
	            }
	        }
	    }
	    throw new IllegalArgumentException("No two sum solution");
	}

2.hashmap
时间复杂度  O(n)
空间复杂度  O(n)

	public static int[] twoSum2(int[] nums, int target){
		Map<Integer, Integer> map = new HashMap<>();
		for(int i= 0;i<nums.length;i++){
			map.put(nums[i], i);
		}
		for (int i = 0; i < nums.length; i++) {
			int complement = target - nums[i];
	        if (map.containsKey(complement) && map.get(complement) != i) {
	            return new int[] { i, map.get(complement) };
	        }
			
		}
		 throw new IllegalArgumentException("No two sum solution");
	}

3.改进的HashMap
时间复杂度  O(n)
空间复杂度  O(n)

	public int[] twoSum3(int[] nums, int target) {
	    Map<Integer, Integer> map = new HashMap<>();
	    for (int i = 0; i < nums.length; i++) {
	        int complement = target - nums[i];
	        if (map.containsKey(complement)) {
	            return new int[] { map.get(complement), i };
	        }
	        map.put(nums[i], i);
	    }
	    throw new IllegalArgumentException("No two sum solution");
	}
