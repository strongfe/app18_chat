override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    setContentView(R.layout.activity_main)
    
    // 데이터 초기화 로그 추가
    Log.d("MainActivity", "데이터 로딩 시작")
    
    // RecyclerView 어댑터 초기화 확인
    recyclerView.adapter = chatAdapter
    recyclerView.layoutManager = LinearLayoutManager(this)
} 