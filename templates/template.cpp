#include<bits/stdc++.h>
using namespace std;
#define endl '\n'
#define int long long
using bigint = __int128;
using ld = long double;
using pi = pair<int,int>;
using pl = pair<int,int>;
using pd = pair<ld,ld>;
#define mp make_pair
#define f first
#define s second
#define sz(x) (int)x.size()
#define all(x) x.begin(),x.end()
#define rall(x) x.rbegin(),x.rend()
#define lb lower_bound
#define ub upper_bound
#define each(x,a) for(auto& x : a)
#define rep(n) for(int i=0 ;i<n;i++)
#define rrep(n) for(int i = n-1;i>=0;i--)
#define tfun(NAME, PARAMS, BODY) template<class T> constexpr T NAME PARAMS { return BODY; }
#define fun(TYPE, NAME, PARAMS, BODY) constexpr TYPE NAME PARAMS { return BODY; }
tfun(cdiv, (T a, T b), a / b + ((a ^ b) > 0 && a % b))
tfun(fdiv, (T a, T b), a / b - ((a ^ b) < 0 && a % b))
fun(int, popcnt, (int x), __builtin_popcount(x))
fun(int, clz,    (int x), __builtin_clz(x))
fun(int, clzll,  (int x), __builtin_clzll(x))
fun(int, ctz,    (int x), __builtin_ctz(x))
fun(int, ctzll,  (int x), __builtin_ctzll(x))
fun(int, msb,    (int x), 31 - clz(x))
fun(int, msbll,  (int x), 63 - clzll(x))
fun(bool, close, (ld a, ld b), abs(a - b) <= 1e-8)
template<class T>
void remdup(vector<T>& v) {
    sort(aint(v));
    v.erase(unique(all(v)),v.end());
}
template<class T,class F>
T firstT(T start, T end, T ans, F check) {
    while(start <= end) {
        T mid = start + (end - start) / 2;
        if(check(mid)) ans = mid,end = mid - 1;
        else start = mid + 1;
    }
    return ans;
}
template<class T,class F>
T lastT(T start,T end,T ans, F check) {
    while(start <= end) {
        T mid = start + (end - start) / 2;
        if(check(mid)) ans = mid,start = mid + 1;
        else end = mid - 1;
    }
    return ans;
}
constexpr int inf = 1e18;
constexpr int mod = 1e9 + 7;
constexpr int mxn = 1e5+5;
constexpr ld eps = 1e-8;

inline void solve() {
    
}

int32_t main() {
    ios::sync_with_stdio(false);
    cin.tie(nullptr);
    int t;
    cin >> t;
    for(int i = 1 ; i <= t ; i++) {
        solve();
    }
    return 0;
}