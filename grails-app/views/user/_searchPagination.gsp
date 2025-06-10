<g:if test="${searchCount > 0}">
    <nav aria-label="Search results pagination">
        <ul class="pagination">
            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                <button class="page-link" onclick="loadSearchResults(${Math.max(0, offset - max)})" ${currentPage == 1 ? 'disabled' : ''}>Previous</button>
            </li>
            
            <g:set var="startPage" value="${Math.max(1, currentPage - 2)}"/>
            <g:set var="endPage" value="${Math.min(totalPages, currentPage + 2)}"/>
            
            <g:if test="${startPage > 1}">
                <li class="page-item">
                    <button class="page-link" onclick="loadSearchResults(0)">1</button>
                </li>
                <g:if test="${startPage > 2}">
                    <li class="page-item disabled">
                        <span class="page-link">...</span>
                    </li>
                </g:if>
            </g:if>
            
            <g:each in="${(startPage..endPage)}" var="pageNumber">
                <li class="page-item ${pageNumber == currentPage ? 'active' : ''}">
                    <button class="page-link" onclick="loadSearchResults(${(pageNumber - 1) * max})">${pageNumber}</button>
                </li>
            </g:each>
            
            <g:if test="${endPage < totalPages}">
                <g:if test="${endPage < totalPages - 1}">
                    <li class="page-item disabled">
                        <span class="page-link">...</span>
                    </li>
                </g:if>
                <li class="page-item">
                    <button class="page-link" onclick="loadSearchResults(${(totalPages - 1) * max})">${totalPages}</button>
                </li>
            </g:if>
            
            <li class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
                <button class="page-link" onclick="loadSearchResults(${offset + max})" ${currentPage >= totalPages ? 'disabled' : ''}>Next</button>
            </li>
        </ul>
    </nav>
</g:if>
