const express = require('express');
const { getArticles, createArticle, updateArticle, toggleArticleStatus, getArticleByName } = require('../controllers/articleController');

const router = express.Router();

router.get('/', getArticles);
router.get('/name/:name', getArticleByName);
router.post('/', createArticle);
router.put('/:id', updateArticle);
router.patch('/:id/toggle', toggleArticleStatus);

module.exports = router;