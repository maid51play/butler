import React from 'react';
import PropTypes from 'prop-types';
import Pagination from 'react-bootstrap/Pagination';

const pagination = ({
  url, pageNumber, totalPages,
}) => {
  const pages = [...Array(totalPages + 1).keys()]
    .slice(
      Math.max(1, pageNumber - 2),
      pageNumber + 3,
    );

  const paginationItem = number => (
    <Pagination.Item key={number} active={number === pageNumber} href={`${url}?page=${number}`}>
      {number}
    </Pagination.Item>
  );

  return totalPages > 1 ? (
    <Pagination>
      <Pagination.Item href={`${url}?page=1`}>start</Pagination.Item>
      {pageNumber !== 1 && <Pagination.Prev href={`${url}?page=${pageNumber - 1}`} />}
      {pages.map(paginationItem)}
      {pageNumber !== totalPages && <Pagination.Next href={`${url}?page=${pageNumber + 1}`} />}
      <Pagination.Item href={`${url}?page=${totalPages}`}>end</Pagination.Item>
    </Pagination>
  ) : (<div />);
};
pagination.propTypes = {
  url: PropTypes.string.isRequired,
  pageNumber: PropTypes.number.isRequired,
  totalPages: PropTypes.number.isRequired,
};

pagination.defaultProps = {
};

export default pagination;
