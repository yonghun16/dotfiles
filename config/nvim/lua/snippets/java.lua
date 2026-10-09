package.loaded["snip_utils.header"] = nil -- 공통 모듈 수정 시 즉시 반영 (선택)
local h = require "snip_utils.header"

return {
  h.oj_header {
    tag = "Java",
    body = [[

import java.io.*;
import java.util.*;

public class Main {
    public static void main(String[] args) throws IOException {
        File file = new File("./input_test.txt");
        BufferedReader br = file.exists()
            ? new BufferedReader(new FileReader(file))
            : new BufferedReader(new InputStreamReader(System.in));
        StringTokenizer st;
        StringBuilder sb = new StringBuilder();

        /* 📥 Input */
        // int n = Integer.parseInt(br.readLine());
        // st = new StringTokenizer(br.readLine());
        // List<<Integer>> a = new ArrayList<<>>();
        // for (int i = 0; i << n; i++) a.add(Integer.parseInt(st.nextToken()));

        /* ⚙️ Logic */
        <>

        /* 🚀 Output */
        // sb.append(ans).append('\n');
        System.out.print(sb);
    }
}
]],
  },
  h.file_header(),
}
