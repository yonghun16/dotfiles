package.loaded["custom.snip_utils.header"] = nil -- 공통 모듈 수정 시 즉시 반영 (선택)
local h = require "custom.snip_utils.header"

return {
  h.oj_header {
    tag = "C++",
    body = [[

#include <<cstdio>>
#include <<iostream>>
using namespace std;

using ll = long long;

int main() {
    if (FILE* fp = fopen("./input_test.txt", "r")) {
        fclose(fp);
        freopen("./input_test.txt", "r", stdin);
    }
    ios::sync_with_stdio(false);
    cin.tie(nullptr);

    /* 📥 Input */
    // int n; cin >>>> n;
    // vector<<ll>> a(n);
    // for (auto& x : a) cin >>>> x;

    /* ⚙️ Logic */
    <>

    /* 🚀 Output */
    // cout <<<< ans <<<< '\n';

    return 0;
}
]],
  },
  h.file_header(),
}
