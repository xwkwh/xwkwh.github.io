---
title: Leetcode解题思路（easy） 更新ing
date: 2018-06-21 21:10:26
categories: Leetcode
tags:
	- Leetcode
	- easy
---

## 思路

* 344 reverse string : 1. 暴力 2. 左右指针遍历交换、

* 292 Nim Game ： 找规律4的倍数必输

* 266 **Palindrome Permutation**(回文排列) ：
  利用set，存在删除，否则加入

* 293 Flip Game ：

   这道题让我们把相邻的两个++变成--，真不是一道难题，我们就从第二个字母开始遍历，每次判断当前字母是否为+，和之前那个字母是否为+，如果都为加，则将翻转后的字符串存入结果中即可 

* 258 Add  Digits ： 

  1. 定义暴力  
  2. 找规律，9个一循环

* 104 Maximum Depth of Binary Tree ： 

   求二叉树的最大深度，就用递归，直接return 1 + max(DFS(left), DFS(right))就行 

* **237 Delete Node in a Linked List** ：node的下个节点和next分别赋给它

* 226 Invert Binary Tree ：

   非递归：和层次遍历类似，依次交换左右孩子

   ```java
   q.push(root);
   while (!q.empty()) {
       TreeNode *node = q.front(); q.pop();
       TreeNode *tmp = node->left;
       node->left = node->right;
       node->right = tmp;
       if (node->left) q.push(node->left);
       if (node->right) q.push(node->right);
   }
   ```

   递归：交换根节点左右孩子，递归左右孩子反转

   ```java
   TreeNode *tmp = root->left;
   root->left = invertTree(root->right);
   root->right = invertTree(tmp);
   return root;
   ```

* 283 Move Zeroes : 

   1. 辅助数组
   2. 交换 双指针交换法

* 100 Same Tree：

   递归：DFS递归，

   ```c++
   bool isSameTree(TreeNode *p, TreeNode *q) {
       if (!p && !q) return true;
       if ((p && !q) || (!p && q) || (p->val != q->val)) return false;
       return isSameTree(p->left, q->left) && isSameTree(p->right, q->right);
   }
   ```

   非递归：以同一种遍历同时遍历树，比较节点

* 242 Valid Anagram ：数组 、map、hash表

* 217 Contains Duplicate ：hash表，或 排序，比较前后俩个值

* 171 Excel Sheet Column Number ：26进制转十进制

* 169 Majority Element （众数）：1.排序取n/2值 2.摩尔投票法 

   ```java
   int res = 0, cnt = 0;
   for (int num : nums) {
       if (cnt == 0) {res = num; ++cnt;}
       else if (num == res) ++cnt;
       else --cnt;
   }
   return res;
   ```

*  235 Lowest Common Ancestor of a Binary Search Tree 

   **思路：**由于是一棵二叉搜索树，所以是有序的，那么可以用递归的方法，如果p和q在root的两边，则root就是我们要的点，否则，就分别返回左子树和右子树的递归结果。 

* 328 Odd Even Linked List 

* 206 Reverse Linked List 

* 13 Roman to Integer 

* 345 Reverse Vowels of a String ：和反转字符串类似

* 191 Number of 1 Bits ：位操作，&1判断1，>>1右移一位

* 70 Climbing Stairs ：斐波那契数列：递归；DP

* 83 Remove Duplicates from Sorted List ：双指针

* 263 Ugly Number ：不停的除以这些质数

* 202 Happy Number ：根据定义如果有一个数循环出现了则false；找规律，有4的不是

* 326 Power of Three ： 暴力除3；有一个trick技巧，就是不用任何循环，直接return n>0 && 1162261467%n == 0; 就行 

* 231 Power of Two ：判断一个数是否是2的幂，思路和上题类似，循环方法用了8ms，第二种trick就是直接return n>0 && 4294967296%n==0; 

* 121 Best Time to Buy and Sell Stock ：

   **思路** ：只需要遍历一次数组，用一个变量记录遍历过数中的最小值，然后每次计算当前值和这个最小值之间的差值最为利润，然后每次选较大的利润来更新。当遍历完成后当前利润即为所求 

   ```java
   public int maxProfit(int[] prices) {
       int res = 0, buy = Integer.MAX_VALUE;
       for (int price : prices) {
           buy = Math.min(buy, price);
           res = Math.max(res, price - buy);
       }
       return res;
   }
   ```

* **24 Swap Nodes in Pairs** :

   递归：

   ```c++
    ListNode* swapPairs(ListNode* head) {
        if (!head || !head->next) return head;
        ListNode *t = head->next;
        head->next = swapPairs(head->next->next);
        t->next = head;
        return t;
    }
   ```

   非递归：

   ```c++
    ListNode* swapPairs(ListNode* head) {
        ListNode *dummy = new ListNode(-1), *pre = dummy;
        dummy->next = head;
        while (pre->next && pre->next->next) {
            ListNode *t = pre->next->next;
            pre->next->next = t->next;
            t->next = pre->next;
            pre->next = t;
            pre = t->next;
        }
        return dummy->next;
    }
   ```

* 110 Balanced Binary Tree   

   **思路：**判断一棵树是否是平衡二叉树，即对于树中的任一节点，其左子树和右子树的高度差小于等于1才行。所以这里需要用到一个求树的高度的函数，如下 

   ```c++
   int depth(TreeNode* root) {  
       return root?max(depth(root->left),depth(root->right))+1:0;  
   } 
   ```

   然后判断是否时平衡树

   ```c++
   bool isBalanced(TreeNode* root) {  
       return root ? abs(depth(root->left)-depth(root->right)) <=1			                                 && isBalanced(root>left) && isBalanced(root->right) : 1;  
   }  
   ```

* **198 House Robber  :DP**，分别维护两个变量a和b，然后按奇偶分别来更新a和b，这样就可以保证组成最大和的数字不相邻 

   ```c++
    int rob(vector<int> &nums) {
        int a = 0, b = 0;
        for (int i = 0; i < nums.size(); ++i) {
            if (i % 2 == 0) {
                a = max(a + nums[i], b);
            } else {
                b = max(a, b + nums[i]);
            }
        }
        return max(a, b);
    }	
   ```


* 102 Binary Tree Level Order Traversal  : 层次遍历

* 107 Binary Tree Level Order Traversal II 

* **27 Remove Element** ：和链表类似，我们只需要一个变量用来计数，然后遍历原数组，如果当前的值和给定值不同，我们就把当前值覆盖计数变量的位置，并将计数变量加1
  ```c++
    int removeElement(vector<int>& nums, int val) {
        int res = 0;
        for (int i = 0; i < nums.size(); ++i) {
            if (nums[i] != val) nums[res++] = nums[i];
        }
        return res;
    }
  ```

* 26 Remove Duplicates from Sorted Array : 双指针，快的去遍历，慢的是不同的

  ```c++
  int removeDuplicates(vector<int>& nums) {
          if (nums.empty()) return 0;
          int j = 0, n = nums.size();
          for (int i = 0; i < n; ++i) {
              if (nums[i] != nums[j]) nums[++j] = nums[i];
          }
          return j + 1;
   } 
  ```

* 342 Power of Four 判断4的次方数：暴力解除以4；转成对数求解log；是2的次方数了之后，发现只要是4的次方数，减1之后可以被3整

  ```c++
  bool isPowerOfFour(int num) {
          return num > 0 && !(num & (num - 1)) && (num - 1) % 3 == 0;
  }
  ```

*  66 Plus One:简单的大数加法，遍历数组的每位，同时处理进位，如果最后还有进位，则在数组最前面在插入1即可

  ```java
  public int[] plusOne(int[] digits) {
          int n = digits.length;
          for (int i = digits.length - 1; i >= 0; --i) {
              if (digits[i] < 9) {
                  ++digits[i];
                  return digits;
              }
              digits[i] = 0;
          }
          int[] res = new int[n + 1];
          res[0] = 1;
          return res;
  }
  ```

*  118 Pascal's Triangle :杨辉三角，找规律，一个数等于他前面肩上俩数的和

*  172 Factorial Trailing Zeroes

  **思路：**简给定一个数n，求n的阶乘的末尾有几个0，细细一想，求它有多少个0，其实就是求它的质因数有多少个(2*5)的存在，根据归纳法可以证明，一个数的阶乘的质因子中2是远远多于5的，所以只要求它的质因子中有多少个5就行了。

*  119 Pascal's Triangle II：要求出给定的一行，空间复杂度要求为O(k)，

  ```c++
  vector<int> getRow(int rowIndex) {
          vector<int> out;
          if (rowIndex < 0) return out;
          
          out.assign(rowIndex + 1, 0);
          for (int i = 0; i <= rowIndex; ++i) {
              if ( i == 0) {
                  out[0] = 1;
                  continue;
              }
              for (int j = rowIndex; j >= 1; --j) {
                  out[j] = out[j] + out[j-1];
              }
          }
          return out;
      }
  ```

*  **112 Path Sum**

*  9 Palindrome Number

* **225 Implement Stack using Queues**

* 111 Minimum Depth of Binary Tree

* **160 Intersection of Two Linked Lists**

* **88 Merge Sorted Array**

* 
