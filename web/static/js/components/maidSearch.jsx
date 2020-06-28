import React, { useState } from 'react';
import PropTypes from 'prop-types';

const maidSearch = ({ search }) => {
  const [searchState, setSearchState] = useState(search || '');

  const onSearch = (e) => {
    e.preventDefault();
    window.location.assign(`/maids?search=${searchState}`);
  };

  return (

    <form id="maidSearchForm" className="search-container" onSubmit={onSearch}>
      <div className="form-group search-input">
        <input className="form-control search-input" id="maidSearchInput" value={searchState} onChange={e => setSearchState(e.target.value)} />
      </div>

      <div className="form-group">
        <button className="btn btn-primary search-button" id="maidSearchBtn" type="submit">Search</button>
        {console.log(search)}
        {search.length > 0 && <a href="/maids" className="btn btn-secondary search-clear-button">x</a>}
      </div>
    </form>

  );
};

maidSearch.propTypes = {
  search: PropTypes.string,
};

maidSearch.defaultProps = {
  search: '',
};

export default maidSearch;
