package.loaded["snip_utils.header"] = nil
local h = require "snip_utils.header"

return {
  h.oj_header {
    tag = "C++",
    body = [[

#include <<cstdio>>
#include <<iostream>>
using namespace std;

using ll = long long;

/* 📥 Input */
void getInputData() {
    if (FILE* fp = fopen("./input_test.txt", "r")) {
        fclose(fp);
        freopen("./input_test.txt", "r", stdin);
    }
    ios::sync_with_stdio(false);
    cin.tie(nullptr);
    
    // int n; cin >> n;
    // vector<<ll>> a(n);
    // for (auto& x : a) cin >> x;
}

/* ⚙️ Logic */
void solution() {
  <>
}

/* 📤 Output */
void printResult() {
}

/* 🚀 Run Program */
int main() {
    getInputData();
    solution();
    printResult();
    return 0;
}
]],
  },
  h.file_header(),
}
