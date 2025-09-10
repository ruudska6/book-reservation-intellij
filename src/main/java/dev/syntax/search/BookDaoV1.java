package dev.syntax.search;

import org.apache.http.HttpHost;
import org.elasticsearch.action.search.SearchRequest;
import org.elasticsearch.action.search.SearchResponse;
import org.elasticsearch.client.*;
import org.elasticsearch.index.query.QueryBuilder;
import org.elasticsearch.index.query.QueryBuilders;
import org.elasticsearch.search.SearchHit;
import org.elasticsearch.search.builder.SearchSourceBuilder;

import java.io.IOException;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class BookDaoV1 {

    private final RestHighLevelClient client;

    public BookDaoV1() {
        this.client = new RestHighLevelClient(
                RestClient.builder(new HttpHost("localhost", 9200, "http")));
    }

    public List<Book> searchBooks(String keyword, String criteria) {
        List<Book> books = new ArrayList<>();

        try {
            // criteria 보정
            if (!("title".equals(criteria) || "author".equals(criteria) || "isbn".equals(criteria))) {
                criteria = "title";
            }

            SearchRequest searchRequest = new SearchRequest("books");
            SearchSourceBuilder builder = new SearchSourceBuilder().size(10000);

            // 🔐 keyword 안전 처리: 없으면 match_all
            QueryBuilder query;
            if (keyword == null || keyword.isBlank()) {
                query = QueryBuilders.matchAllQuery();
            } else if ("isbn".equals(criteria)) {
                // ISBN 부분검색 원하면 wildcard, 정확히 일치만 원하면 termQuery로 바꾸세요
                query = QueryBuilders.wildcardQuery("isbn", "*" + keyword + "*");
            } else {
                query = QueryBuilders.matchQuery(criteria, keyword);
            }

            builder.query(query);
            searchRequest.source(builder);

            SearchResponse response = client.search(searchRequest, RequestOptions.DEFAULT);

            for (SearchHit hit : response.getHits().getHits()) {
                try {
                    Map<String, Object> map = hit.getSourceAsMap();

                    Book book = new Book();

                    // bookId (없어도 전체 실패하지 않게)
                    Object bid = map.get("bookId");
                    if (bid != null) {
                        try { book.setBookId(Long.parseLong(bid.toString())); } catch (Exception ignore) {}
                    }

                    book.setTitle(asString(map.get("title")));
                    book.setAuthor(asString(map.get("author")));
                    book.setTranslator(asString(map.get("translator")));
                    book.setPublisher(asString(map.get("publisher"))); // 스키마에 있으니 매핑

                    // pubDate: ISO 형식 대비
                    Object pd = map.get("pubDate");
                    if (pd != null) {
                        String d = pd.toString();
                        if (d.length() >= 10) {
                            try { book.setPubDate(Date.valueOf(d.substring(0, 10))); } catch (Exception ignore) {}
                        }
                    }

                    book.setIsbn(asString(map.get("isbn")));

                    Object pg = map.get("page");
                    if (pg != null) {
                        try { book.setPage(Integer.parseInt(pg.toString())); } catch (Exception ignore) {}
                    }

                    book.setImage(asString(map.get("image")));

                    // catCode: DB가 varchar(50) → 숫자로 못 바꿀 수 있음
                    Object cc = map.get("catCode");
                    if (cc != null) {
                        try {
                            book.setCatCode(Long.parseLong(cc.toString())); // Book이 long이면 시도
                        } catch (Exception ignore) {
                            // catCode가 'A-001' 같은 값이면 여기서 무시되니,
                            // 필요하면 Book에 String catCodeStr 추가하는 걸 권장
                        }
                    }

                    // isBorrow: tinyint(1) → "0"/"1" 혹은 true/false
                    Object ib = map.get("isBorrow");
                    if (ib != null) {
                        boolean b;
                        String v = ib.toString();
                        if ("1".equals(v)) b = true;
                        else if ("0".equals(v)) b = false;
                        else b = Boolean.parseBoolean(v);
                        book.setBorrow(b);
                    }

                    book.setCatName(asString(map.get("catName")));

                    books.add(book);
                } catch (Exception perDoc) {
                    // 한 문서 매핑 중 오류여도 전체 검색은 계속 진행
                    perDoc.printStackTrace();
                }
            }

        } catch (IOException e) {
            e.printStackTrace();
        }

        return books;
    }

    private static String asString(Object o) {
        return o == null ? null : o.toString();
    }

    public void close() throws IOException {
        client.close();
    }
}
