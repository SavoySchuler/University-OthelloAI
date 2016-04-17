#|
                  ***** MINIMAX.LSP *****

Generalized recursive minimax routine.

Author: Dr. John M. Weiss
Class:	SDSM&T CSC447/547 Artificial Intelligence
Date: 	Spring 2016

Usage:    (minimax position depth)
          where position is the position to be evaluated,
          and depth is the search depth (number of plys).

Returns:  (value path)
          where value is the backed-up value from evaluation of leaf nodes,
          and path is the path to the desired leaf node.

Functions called:

          (deepenough depth) -
              predicate that returns T if the current position has reached
              the desired search depth, NIL otherwise.

          (move-generator position) -
              generates successors to the position.

          (static position) -
              applies the static evaluation function to the position.

          Note: these functions may need additional arguments.
|#

(defun minimax (position depth color)

	

    ; if we have searched deep enough, or there are no successors,
    ; return position evaluation and nil for the path
    (if (or (deepenough depth) (null (move-generator position color)))
        (list (static position color) nil)				;Heuristic calc
;	(Print (static position color))
;	(PrintOthello position)

        ; otherwise, generate successors and run minimax recursively
        (let
            (
                ; generate list of sucessor positions
                (successors (move-generator position color))
		;(successors (GenerateSuccessors position))		;Name change
                
		; initialize current best path to nil
                (best-path nil)

                ; initialize current best score to negative infinity
                (best-score -1000000)

                ; other local variables
                succ-value
                succ-score
            )
		
            ; explore possible moves by looping through successor positions
            (dolist (successor successors)
		
		
                ; perform recursive DFS exploration of game tree
		
		(if (equal color 'w)
			(setq succ-value (minimax successor (1- depth) 'b))
			(setq succ-value (minimax successor (1- depth) 'w))
		)
		
                ; change sign every ply to reflect alternating selection
                ; of MAX/MIN player (maximum/minimum value)
                (setq succ-score (- (car succ-value)))
		
                ; update best value and path if a better move is found
                ; (note that path is being stored in reverse order)
                (when (> succ-score best-score)
                      (setq best-score succ-score)
                      (setq best-path (cons successor (cdr succ-value)))
                )
            )

            ; return (value path) list when done
            (list best-score best-path)
        )
    )
)

(defun deepenough (depth)
	(if (eq 0 depth) 
		t
		nil
	)
)


(defun static (position color)
	(let (sum numBlanks)
	(setf sum 0)
	(setf sum (+ sum (cornerHeuristic position color)))
	(setf sum (+ sum (aroundCornerHeuristic position color)))
	
	
	(setf numBlanks 0)	

	;find out how many blank spaces remain
	(dolist (tilePiece *board*)  
	 	(when (equal tilePiece '-) 
			(setf numBlanks (+ numBlanks 1))
		)
	)

	;heuristic to play for less pieces early on, then reverse
	(if (< sumBlanks 25)
		(setf sum (+ sum (morePlayerCount position color)))
		(setf sum (+ sum (moreOpponentCount position color)))
	)

	sum	
	)
)

