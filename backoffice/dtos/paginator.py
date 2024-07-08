import math

class PaginatorDTO:
    def __init__(self, items, totalItems: int, limitPerPage: int, currentPage: int):
        self.items = items
        self.totalItems = totalItems
        self.limitPerPage = limitPerPage
        self.totalPages = math.ceil(self.totalItems / self.limitPerPage)
        self.currentPage = currentPage

    def serialize(self):
        return {
            'items': self.items,
            'currentPage': self.currentPage,
            'nextPage': self.currentPage + 1 if self.totalPages > 1 and self.currentPage < self.totalPages else None,
            'previousPage': self.currentPage - 1 if self.currentPage - 1 > 0 else None,
            'totalPages': self.totalPages,
            'totalItems': self.totalItems
        }