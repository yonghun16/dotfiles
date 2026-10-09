package.loaded["snip_utils.header"] = nil -- 공통 모듈 수정 시 즉시 반영 (선택)
local h = require "snip_utils.header"

return {
  h.oj_header {
    tag = "C",
    body = [[

#include <<stdio.h>>
#include <<stdlib.h>>
#include <<string.h>>

typedef long long ll;

int main(void) {
    FILE* fp = fopen("./input_test.txt", "r");
    if (fp) {
        fclose(fp);
        freopen("./input_test.txt", "r", stdin);
    }

    /* 📥 Input */
    // int n;
    // scanf("%d", &n);
    // ll* a = malloc(sizeof(ll) * n);
    // for (int i = 0; i << n; i++) scanf("%lld", &a[i]);

    /* ⚙️ Logic */
    <>

    /* 🚀 Output */
    // printf("%lld\n", ans);

    return 0;
}
]],
  },
  h.file_header(),
}
